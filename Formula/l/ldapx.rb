class Ldapx < Formula
  desc "Flexible LDAP proxy for inspecting and transforming LDAP traffic"
  homepage "https://github.com/Macmod/ldapx"
  url "https://github.com/Macmod/ldapx/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "fec47b73d34ac050c7107fa04614116d68895d9e63b6ecd371da224b7cac3ae0"
  license "MIT"
  head "https://github.com/Macmod/ldapx.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/Macmod/ldapx/internal/app.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    require "socket"
    require "timeout"

    upstream = TCPServer.new("127.0.0.1", 0)
    target_port = upstream.addr[1]
    listen_port = free_port

    pid = spawn bin/"ldapx", "--no-shell", "--no-colors",
                "--listen", "127.0.0.1:#{listen_port}",
                "--target", "127.0.0.1:#{target_port}"
    begin
      client = nil
      Timeout.timeout(10) do
        loop do
          client = TCPSocket.new("127.0.0.1", listen_port)
          break
        rescue Errno::ECONNREFUSED
          sleep 0.1
        end
      end

      Timeout.timeout(10) do
        conn = upstream.accept
        refute_nil conn
        conn.close
      end
    ensure
      client&.close
      Process.kill "TERM", pid
      Process.wait pid
      upstream.close
    end
  end
end
