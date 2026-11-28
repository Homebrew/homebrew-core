class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.25.56.tar.gz"
  sha256 "342d8c4968c0db32a538c21e8fadb7f6174555cd44f58f0efbe99a945fd46be3"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    manifest_sha256 "e2920d8189de67093e7507b272a2631401a2f4fab38818426817babe87624c30"
    sha256 cellar: :any, arm64_golden_gate: "14e1f16fb1b6ae787cbf1520260e462773b302670fde6426dc9cbd510a989917"
    sha256 cellar: :any, arm64_tahoe:       "6fbe6d9874a52ee2643b622b79634938ccb793087970240d6bcf704213bf0fec"
    sha256 cellar: :any, arm64_sequoia:     "b4662c38d428bbaa436e758a9d34902a293053766503461044b439599f1279e9"
    sha256 cellar: :any, arm64_linux:       "7103001c5d4e80a087efafc246ea2c0b3c2be25d1bf8416db82f6c69ba36e50a"
    sha256 cellar: :any, x86_64_linux:      "62e7327a6291318144e32630f2ce09abea09e09145ccae366744f32a8d13b5d4"
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
