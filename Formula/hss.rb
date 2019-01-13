class Hss < Formula
  desc "Interactive parallel SSH client"
  homepage "https://github.com/six-ddc/hss"
  url "https://github.com/six-ddc/hss/archive/1.7.tar.gz"
  sha256 "99371c15fde236c806f7b6ed21b12bafc4f559fcbb636e0ab2112b09faa0e44a"
  revision 1

  bottle do
    cellar :any
    sha256 "c8e8166c15f2a792691b585aa5af44a7c6c297ea4c70614dd340f64f2cc2fbf5" => :mojave
    sha256 "7a4d3e7c1e1d5e8c3fa106bc4288b4eeb827d86f4acaa803ed3478d5edb381ce" => :high_sierra
    sha256 "0a14f3991bff524b5a0f5510e85e4cc715ae1ca1d746ef838f5fccc17c00f55d" => :sierra
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
