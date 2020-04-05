class Hss < Formula
  desc "Interactive parallel SSH client"
  homepage "https://github.com/six-ddc/hss"
  url "https://github.com/six-ddc/hss/archive/1.8.tar.gz"
  sha256 "60481274403c551f5b717599c813d619877a009832c4a8a84fcead18e39382fa"

  bottle do
    cellar :any
    sha256 "709da9ba5497dd3d76b8b425f6a74c8b6014e23a0a85b5b1498d6ac0137b15cd" => :catalina
    sha256 "bc7f0e8a54effd65cae855164b7ea0d287af079ceec01accebb74f476e04c863" => :mojave
    sha256 "e6b884c0c3f45c0365c39d65f644281c0079899b96d7835ad7fdab6e2e67c338" => :high_sierra
    sha256 "4d23f98a3af8e2facd71c61616a207bb7c990bb2b9c5c52ca9a772cc6aecd0be" => :sierra
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
          :out => hss_write
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
