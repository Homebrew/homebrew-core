class Hss < Formula
  desc "Interactive parallel SSH client"
  homepage "https://github.com/six-ddc/hss"
  url "https://github.com/six-ddc/hss/archive/1.7.tar.gz"
  sha256 "99371c15fde236c806f7b6ed21b12bafc4f559fcbb636e0ab2112b09faa0e44a"

  bottle do
    cellar :any
    sha256 "9a41aa73345f45ad440ae92c188c9ea6ff868d128024fcfd2abe39b2a3aa027a" => :high_sierra
    sha256 "b16182f23f97fbd1dac75f6b61264e39084c03a7864f37940127bf4460fd76f8" => :sierra
    sha256 "e65e32761d3d0485a62ff9a8826318ab53a6f92aed084435b5dfe0cd9a09a92b" => :el_capitan
  end

  depends_on "readline"

  def install
    system "make"
    system "make", "install", "INSTALL_BIN=#{bin}"
  end

  test do
    require "socket"
    begin
      server = TCPServer.new(0)
      port = server.addr[1]
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
