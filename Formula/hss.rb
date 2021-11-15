class Hss < Formula
  desc "Interactive parallel SSH client"
  homepage "https://github.com/six-ddc/hss"
  url "https://github.com/six-ddc/hss/archive/1.8.tar.gz"
  sha256 "60481274403c551f5b717599c813d619877a009832c4a8a84fcead18e39382fa"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5268e0b2047f74728df213efdbd9a4911946b6bf82db1d26a004668293da2c75"
    sha256 cellar: :any,                 arm64_big_sur:  "b522779da8a44d558d8c5aca8434f782eb5201277c3e39c25573d875052b1242"
    sha256 cellar: :any,                 monterey:       "806e8ab6251df79392491e5e727f79a0e86368aa52c3f0653bf6f0bc169ed518"
    sha256 cellar: :any,                 big_sur:        "6b131df4a773805b59f7d923b138d25b983a70eb818f0e3704f977254a75ee3a"
    sha256 cellar: :any,                 catalina:       "709da9ba5497dd3d76b8b425f6a74c8b6014e23a0a85b5b1498d6ac0137b15cd"
    sha256 cellar: :any,                 mojave:         "bc7f0e8a54effd65cae855164b7ea0d287af079ceec01accebb74f476e04c863"
    sha256 cellar: :any,                 high_sierra:    "e6b884c0c3f45c0365c39d65f644281c0079899b96d7835ad7fdab6e2e67c338"
    sha256 cellar: :any,                 sierra:         "4d23f98a3af8e2facd71c61616a207bb7c990bb2b9c5c52ca9a772cc6aecd0be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77fb7ffa01e6a77a6ebd605f8117824900b043d6035bcacf68a94159de4ec984"
  end

  depends_on "readline"

  def install
    system "make"
    system "make", "install", "INSTALL_BIN=#{bin}"
  end

  test do
    port = free_port
    begin
      server = TCPServer.new(port)
      accept_pid = fork do
        msg = server.accept.gets
        assert_match "SSH", msg
      end
      hss_read, hss_write = IO.pipe
      hss_pid = fork do
        exec "#{bin}/hss", "-H", "-p #{port} 127.0.0.1", "-u", "root", "true",
          out: hss_write
      end
      server.close
      msg = hss_read.gets
      assert_match "Connection closed by remote host", msg
    ensure
      Process.kill("TERM", accept_pid)
      Process.kill("TERM", hss_pid)
    end
  end
end
