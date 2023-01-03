class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2464.tar.gz"
  sha256 "19ca33097272086fa47e6dd6bd01071ed96d5f6ad4e732c55fc5215e552c3d52"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2303a603108f35bddc860e0441894efab0c01162f0e8187d0b0e3db3ec122fee"
    sha256 cellar: :any,                 arm64_monterey: "edd1b78f78c7a41065ce44d4905c5c722d6d2aaacad0c37ee1a245a63b40c20a"
    sha256 cellar: :any,                 arm64_big_sur:  "79f059d315b79266e3e1753cf11119b82697925f33789a34df4077bc1fac05d4"
    sha256 cellar: :any,                 ventura:        "c2f2bb256d8d47a850da17db027abff74e2e9b13d5b328bc98c1a1683fc40181"
    sha256 cellar: :any,                 monterey:       "cf0bcabce32625fbb6df94d463951be719a07bcbb5f8833db28e32bdaa187c17"
    sha256 cellar: :any,                 big_sur:        "9c84008401e736c0651cc14b4dee5578c4784e2cc54cc2c04928046be08dc8db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10c8d9521ae086da4c23b7f812bda82e59eb74cae1115542ff7684b6c3433492"
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
