#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["multi-stage-build-sample-app.csproj", "."]
RUN dotnet restore "./multi-stage-build-sample-app.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "multi-stage-build-sample-app.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "multi-stage-build-sample-app.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "multi-stage-build-sample-app.dll"]