class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3164.tar.gz"
  sha256 "9d778672f43e6257e1a43f3c283818fd78aa408dcff00376e649f2f1b13b52d2"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3e4aba87233f115049e954a0b379f5f404b32309b92ccb983f366af9b1a51b18"
    sha256 cellar: :any,                 arm64_monterey: "4189dbd141c391bc17e2f522a3628d00d836e8ca8fb591f9194a0cdd067377ba"
    sha256 cellar: :any,                 arm64_big_sur:  "a7f83d17e3c1e63653fe76663fbeb9fd2a8bd1af273c1973dee465ea7e3cb2c4"
    sha256 cellar: :any,                 ventura:        "7208c4ca838543a3cb939fdf806c8c3fa198ccfef27840b42367e0573e8cde5e"
    sha256 cellar: :any,                 monterey:       "bc9ff22b000c643c8388ed4beee9f7b20aface7455a247cf99a70b6dfdbb8271"
    sha256 cellar: :any,                 big_sur:        "e56152c444aea1f80fbf8fe62c38a18402b2af6fd229cbe351f25bb973f61891"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39b9f575e7f8a0a92e9f03d48ff3c0182fbd06d99db11013cfffecee5a24a40a"
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
    working_dir libexec
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
