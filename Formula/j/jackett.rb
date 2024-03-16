class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.2042.tar.gz"
  sha256 "24dc38b1bf7cd8b323cfb56bc51b44ff228b32a4884d7060d484c2548ba40a8e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "edd12369cc63823b3a8c8edf23d393239a70ba0a33a253914b70d29d18d36c64"
    sha256 cellar: :any,                 arm64_monterey: "25bea4fc606303a98234a490326957d09eefb7596aad2a92faf2ec62f63c8846"
    sha256 cellar: :any,                 ventura:        "e190e435433e13bcd997ab1f1fb93524366172758d4e150b4b74dd74811a7ad5"
    sha256 cellar: :any,                 monterey:       "aadc6774137fec115dc30e4d9fac65569bec8890d698de49a706d2638299eb4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffe3c1c43ad9dbff5b2846dfe59c6705ddadb95d9adc5b7e4ebcbc941fe82cc9"
  end

  depends_on "dotnet@6"

  def install
    dotnet = Formula["dotnet@6"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
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

    pid = fork do
      exec "#{bin}/jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 10
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
