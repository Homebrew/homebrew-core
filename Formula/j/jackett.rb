class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.25.48.tar.gz"
  sha256 "7a5fb38c8c052ed3098dde2594672a9c0762a05be4f0970d94f42da77a41b074"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    manifest_sha256 "86c0ac50e350954a161f88bc1d115ea00ed5c28762beef46f35e08469c4edc56"
    sha256 cellar: :any, arm64_golden_gate: "48867056b291dd601f8b2451c0f8e57af4203c5245727135e2c050af515de75d"
    sha256 cellar: :any, arm64_tahoe:       "d45a92c088d71358c1af6afe5cb7ad7d2950586c5e413fc70c5b6d8860a57bb0"
    sha256 cellar: :any, arm64_sequoia:     "266f10ab590402170b91d4f5aec87955a261a2e6e1b5afa07f03d5c3e148e87f"
    sha256 cellar: :any, arm64_linux:       "fd4fc196953f8aeeb5f1ff7cfaa25a5ee5a9e5aeaba70a8e9494359e9cf849db"
    sha256 cellar: :any, x86_64_linux:      "7a5497b55157484abc27c5a2f5413f52a64ec2acf73430959a49e527815984b1"
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
