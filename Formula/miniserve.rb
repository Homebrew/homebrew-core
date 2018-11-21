class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.2.1.tar.gz"
  sha256 "9d58319ae1dcf460f85114e49939ffeae8b6161de7e9dfaf6a7a985d52e998d4"

  bottle do
    sha256 "a3af5e213d0af2c5e899215f638b2b9f47ce71d5d04b15bc36160d1ac1385627" => :mojave
    sha256 "e04be638d9a20ed8481b28a39d12c9232354931313820a612a02b72a28c61cc5" => :high_sierra
    sha256 "a4d01bb0280ea8850b8f01e809d0e659bb971435ca5809b2b21fa26add4a23b5" => :sierra
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
