class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.25.48.tar.gz"
  sha256 "7a5fb38c8c052ed3098dde2594672a9c0762a05be4f0970d94f42da77a41b074"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    manifest_sha256 "09b50a9c1f5933558b78ed3f5efe87f7265b38b1fd8a49c7cffcbc48df9130e6"
    sha256 cellar: :any, arm64_golden_gate: "6bcdc9c831f2298da7b01f6d35ae4bf892497e6f263fada6908bcb9fd6b8bf38"
    sha256 cellar: :any, arm64_tahoe:       "ffa209417af4dfcc6f990e8f9998d7a9ea7f3fcbae6aa623bfe12fc666aacade"
    sha256 cellar: :any, arm64_sequoia:     "1b8638c7f7f5cab93499a1eec17f1fbe1166002ebc8a57eec45e92b6316a11fb"
    sha256 cellar: :any, arm64_linux:       "4fc97988786e6e5a1fb8d5f8ca6f4563f7647f8da0951f320adbb37966001b0f"
    sha256 cellar: :any, x86_64_linux:      "3434a490611bbd69331e1e3a8a899dc6742a12464f5ca1aa46eef8ae03ed3660"
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
