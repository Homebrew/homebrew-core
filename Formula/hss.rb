class Hss < Formula
  desc "Interactive parallel SSH client"
  homepage "https://github.com/six-ddc/hss"
  url "https://github.com/six-ddc/hss/archive/1.7.tar.gz"
  sha256 "99371c15fde236c806f7b6ed21b12bafc4f559fcbb636e0ab2112b09faa0e44a"
  revision 1

  bottle do
    cellar :any
    sha256 "4b4aadb0f3935c404a5d5393014ea31bc07a84b108cb04c76ea64b4a67dc0fab" => :mojave
    sha256 "ec49670b43be250497c97a41d2f738dbb3dcca71bf3663cd27c19395e06d0eee" => :high_sierra
    sha256 "3c268369dce6e3c48be16c08e488ec83020823f505833396828637337d05b898" => :sierra
    sha256 "c8932b0fe8958a4240adde3b739a507846f43054d750ecb2aacfb65db1067924" => :el_capitan
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
