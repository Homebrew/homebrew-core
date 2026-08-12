class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2398.tar.gz"
  sha256 "7594f58c2748baff3c876d93f2f12d809d78edb013f1f31f92c0248b561c64f1"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "51dbb7195c996976bb04a6030f0045cf220dd85e8151e0393eaf747e65ecdcfa"
    sha256 cellar: :any, arm64_sequoia: "4d4ce93af08328b80598cacd2cb8b75245c570e1a24d40ee781d3fdfc2be2b64"
    sha256 cellar: :any, arm64_sonoma:  "01e05281ce5f0c876c21ec721932cb51e2289a04f3b49c96395dba41aaa12472"
    sha256 cellar: :any, sonoma:        "737a03998218e2044209a2019d28e0d12edb574a796c608686fe3a139793e5ca"
    sha256 cellar: :any, arm64_linux:   "ed559b472eda66deae06cd2387cf8622a864ec70f7791e375c8b9ec21702476b"
    sha256 cellar: :any, x86_64_linux:  "428390a0f50539811ef2e744fc5b08e95c2709a671038308d192001bb7fdfcf0"
  end

  # Aligned to .NET dependency. Can remove if updated to latest .NET
  deprecate! date: "2026-11-10", because: "needs end-of-life .NET 9"
  disable! date: "2027-11-10", because: "needs end-of-life .NET 9"

  depends_on "dotnet@9"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@9"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
    ]
    if build.stable?
      args += %W[
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = spawn bin/"jackett", "-d", testpath, "-p", port.to_s

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
