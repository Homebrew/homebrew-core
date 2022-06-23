class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.6.20.tar.gz"
  sha256 "6a1555e31f1403744248eeb1eb07631ec322cfc9594bba8a4e031b381592b9d0"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8407f799cec4723d7244dec71ba925e87f91a2a316f8a9e83d9a3fd5eabd36d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a56d0797435cdcab945f3db2f0c4c4982bff6867b53140f734450b0207e6713"
    sha256 cellar: :any_skip_relocation, monterey:       "ee1807449afb195bfbbc63e0233916e4a8a1ed30d5e87279ce40501b5e0a868d"
    sha256 cellar: :any_skip_relocation, big_sur:        "01e654dcec06074346dd45b985b116f494524f3401d8d1c975b514491b2eaca6"
    sha256 cellar: :any_skip_relocation, catalina:       "a891436e41183f189e808b9095cfe2883cfc107ee0adcc2fad5bce3b17b266e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "385fda78d9f806ca3d3d175aa6b088d64016deed970a175e0e3282843f2ad72a"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fn --version")
    system "#{bin}/fn", "init", "--runtime", "go", "--name", "myfunc"
    assert_predicate testpath/"func.go", :exist?, "expected file func.go doesn't exist"
    assert_predicate testpath/"func.yaml", :exist?, "expected file func.yaml doesn't exist"
    port = free_port
    server = TCPServer.new("localhost", port)
    pid = fork do
      loop do
        response = {
          id:         "01CQNY9PADNG8G00GZJ000000A",
          name:       "myapp",
          created_at: "2018-09-18T08:56:08.269Z",
          updated_at: "2018-09-18T08:56:08.269Z",
        }.to_json

        socket = server.accept
        socket.gets
        socket.print "HTTP/1.1 200 OK\r\n" \
                     "Content-Length: #{response.bytesize}\r\n" \
                     "Connection: close\r\n"
        socket.print "\r\n"
        socket.print response
        socket.close
      end
    end
    sleep 1
    begin
      ENV["FN_API_URL"] = "http://localhost:#{port}"
      ENV["FN_REGISTRY"] = "fnproject"
      expected = "Successfully created app:  myapp"
      output = shell_output("#{bin}/fn create app myapp")
      assert_match expected, output.chomp
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
