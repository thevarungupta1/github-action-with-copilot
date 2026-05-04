# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

COPY SampleApii.csproj ./
RUN dotnet restore

COPY . .
RUN dotnet build --no-restore --configuration Release --output /app/build

# Stage 2: Publish
FROM build AS publish
RUN dotnet publish --no-build --configuration Release --output /app/publish

# Stage 3: Release
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS release
WORKDIR /app

COPY --from=publish /app/publish .

EXPOSE 8080
ENTRYPOINT ["dotnet", "SampleApii.dll"]
