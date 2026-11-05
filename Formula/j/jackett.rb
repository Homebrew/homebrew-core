class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.3014.tar.gz"
  sha256 "276d97d983deeed311f6e3acc0d4d0259c764dfeb7e021ba250a847b1f64765e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a6e5c23982970c49471d6fc188153f6f1817c9650a119001948de7c6995dbc22"
    sha256 cellar: :any, arm64_tahoe:       "28d8dcc02680a86da17507f7cf939bb8eeb039d43a9b99167d8db4f295451c9f"
    sha256 cellar: :any, arm64_sequoia:     "adb26ecd5400962c84a1ff557f62a05fdac7530c8565ab8426d6fb5971212439"
    sha256 cellar: :any, arm64_linux:       "3925b7075a21a72c87b58d13e4bbc2eda94434260aa3253d81c51d577405299d"
    sha256 cellar: :any, x86_64_linux:      "8b21951dc868260ce6d6ba152bba9d1ba40fa1a83331cd1ccb67a737b0fc88ce"
  end

  # Aligned to .NET dependency. Can remove if updated to latest .NET
  deprecate! date: "2026-11-10", because: "needs end-of-life .NET 9"
  disable! date: "2027-11-10", because: "needs end-of-life .NET 9"

  depends_on "dotnet@9"

  allow_network_access! :test

  def dotnet = deps.find { |d| d.name.match?(/^dotnet(@\d+)?$/) }.to_formula

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
