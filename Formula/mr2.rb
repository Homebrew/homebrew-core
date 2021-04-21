class Mr2 < Formula
  desc "Expose local server to external network"
  homepage "https://github.com/txthinking/mr2"
  url "https://github.com/txthinking/mr2/archive/refs/tags/v20210401.tar.gz"
  sha256 "3cf2874a5945e79fd9ca270181de1a9d6a662434455c58e2e20e5dbfdebd64c7"
  license "GPL-3.0-only"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli/mr2"
  end

  test do
    (testpath/"index.html").write <<~EOF
      <!DOCTYPE HTML>
      <html>
      <body>
        <p>passed</p>
      </body>
      </html>
    EOF
    mr2_server_port = free_port
    server_port = free_port
    client_port = free_port
    server_pid = fork { exec bin/"mr2", "server", "-l", ":#{mr2_server_port}", "-p", "password" }
    sleep 5
    client_pid = fork do
      exec bin/"mr2", "client", "-s", "127.0.0.1:#{mr2_server_port}",
                                "-p", "password",
                                "--serverPort", server_port.to_s,
                                "--clientDirectory", testpath,
                                "--clientPort", client_port.to_s
    end
    sleep 3
    output = shell_output "curl 127.0.0.1:#{server_port}"
    assert_match "passed", output
  ensure
    Process.kill "SIGTERM", server_pid, client_pid
  end
end
