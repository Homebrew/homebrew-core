class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.4.1.tar.gz"
  sha256 "61209f69bf6cabd130ce393e0e3a90ef9d78be2320d87e2047e9a35bf51041e2"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8955f888b8c0828d741d5541a2ae6567704d78db99600d59b3d9a02dc571089" => :mojave
    sha256 "8711ae0bb727abd3ed3ad8d1335275d26fbc473f19bacfbad76b10b5a0bf4efc" => :high_sierra
    sha256 "a00b82cfce9fecd067b62ec3135a0e9cc59d3133f97ed3c0e7b815e4921c32d0" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    require "socket"

    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

    pid = fork do
      exec "#{bin}/miniserve", "#{bin}/miniserve", "--if", "127.0.0.1", "--port", port.to_s
    end

    sleep 2

    begin
      read = (bin/"miniserve").read
      assert_equal read, shell_output("curl localhost:#{port}")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
