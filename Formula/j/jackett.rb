class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.25.28.tar.gz"
  sha256 "dd25bc83aba2e8b06922bdb4f479af7b133044de8cf5469ef765f98eba8367fc"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    manifest_sha256 "13c7c117c8220a9eaf7dc27ba3cf15b49c85f1a289e9b5aa36fd26532c160423"
    sha256 cellar: :any, arm64_golden_gate: "ead3e81404643314b0a82fa95d3f06268f39098c15ce482504454c30188fefb0"
    sha256 cellar: :any, arm64_tahoe:       "83bf34382e13a059a5a82c2b2d6f4b71654f4484cc1a3854a37d622e5e308813"
    sha256 cellar: :any, arm64_sequoia:     "88b663be04af7a0575e8bb1509e38fe2f6dd91f30a62bd9e1350df86fa3e0d12"
    sha256 cellar: :any, arm64_linux:       "0dad7d69967733c29a6fe91c18c72df2f00e94bfd0e866c6de47071c481a9705"
    sha256 cellar: :any, x86_64_linux:      "efeb56a1f197783fee11431035e4bb2d23d3de235a6e6c056a3f8129b9108821"
  end

  depends_on "dotnet@10"

  allow_network_access! :test

  def dotnet = dep("dotnet").to_formula

  def fetch
    ENV["XDG_RUNTIME_DIR"] = buildpath

    system "dotnet", "restore", "src/Jackett.Server", "--use-current-runtime"
  end

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"
    ENV["XDG_RUNTIME_DIR"] = buildpath

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
    # The sandbox denies FSEvents, so .NET's config file watcher would hang
    ENV["DOTNET_USE_POLLING_FILE_WATCHER"] = "1" if OS.mac?

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
