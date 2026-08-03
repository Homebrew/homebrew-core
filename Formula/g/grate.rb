class Grate < Formula
  desc "SQL migration tool using plain SQL scripts"
  homepage "https://grate-devs.github.io/grate/"
  url "https://github.com/grate-devs/grate/archive/refs/tags/2.1.6.tar.gz"
  sha256 "456d83d3ce605720241fd32b386c2a2f9f1adefaa11af77bfcbcb0bd5e1090b5"
  license "MIT"
  head "https://github.com/grate-devs/grate.git", branch: "main"

  depends_on "dotnet" => :build
  depends_on "brotli"

  on_linux do
    depends_on "icu4c@78"
    depends_on "libunwind"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_NOLOGO"] = "1"

    # Use Homebrew's supported SDK rather than the feature band pinned upstream.
    rm "global.json"

    dotnet = Formula["dotnet"]
    framework = "net#{dotnet.version.major_minor}"
    args = %W[
      --configuration Release
      --framework #{framework}
      --output #{libexec}
      --self-contained
      --use-current-runtime
      -p:DebugType=None
      -p:IncludeNativeLibrariesForSelfExtract=true
      -p:PublishSingleFile=true
      -p:TargetFrameworks=#{framework}
    ]
    args << "-p:Version=#{version}" if build.stable?

    system "dotnet", "publish", "src/grate/grate.csproj", *args
    bin.install libexec/"grate"
  end

  test do
    scripts = testpath/"scripts/up"
    scripts.mkpath
    (scripts/"001_create_widgets.sql").write <<~SQL
      CREATE TABLE widgets (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL
      );
    SQL

    database = testpath/"grate-test.db"
    system bin/"grate",
           "--connectionstring", "Data Source=#{database}",
           "--databasetype", "sqlite",
           "--sqlfilesdirectory", testpath/"scripts",
           "--output", testpath/"output",
           "--version", version.to_s,
           "--silent"

    assert_path_exists database
    assert_predicate database, :size?
  end
end
