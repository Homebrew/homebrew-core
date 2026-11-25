class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.25.39.tar.gz"
  sha256 "65d687c6278de3d863f1a4478c74d2ed9f2dd8b2cb8db17cec6aaaa28d3d35e9"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    manifest_sha256 "f7c2dafdf09caeae67647cd1f1bffcb49d319fc425565fff1dd18996cc714e70"
    sha256 cellar: :any, arm64_golden_gate: "3b00e89c9ae132d8f7df51f4b108a4b60447d21b7e1742277b01ca9465a77f3c"
    sha256 cellar: :any, arm64_tahoe:       "a885b4388f0b181b74c6451ec5e4d679ea83cf2337d2890e3a8f16b47dec8d13"
    sha256 cellar: :any, arm64_sequoia:     "ac7816ef3714c1dea138b3b1ed11b2056d43e639bdda709dd2deb607cbf2c718"
    sha256 cellar: :any, arm64_linux:       "e11b5c438d6f9649c42c10d2aae981bfa52b822af00cc5ff2a1693181a08e4de"
    sha256 cellar: :any, x86_64_linux:      "ebeef286cefe8ddf88f9e720b75309dbb7099cbe3ab9fdc420d46be2b0577135"
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
