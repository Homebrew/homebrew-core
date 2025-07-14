class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/refs/tags/0.6.42.tar.gz"
  sha256 "d89758dadc2859da8bb1b7b0356b8bd9bb6a12d9aa118cd2c1429639153e90f1"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc75dcc9e25a754b2496f20be3e7ca5a0f2a169aeb161e001b1901b743742b16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc75dcc9e25a754b2496f20be3e7ca5a0f2a169aeb161e001b1901b743742b16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc75dcc9e25a754b2496f20be3e7ca5a0f2a169aeb161e001b1901b743742b16"
    sha256 cellar: :any_skip_relocation, sonoma:        "1be537487a7c5e06b6294e7f0bdd909577be3ac20bc24f86a1492e5d141ca2dd"
    sha256 cellar: :any_skip_relocation, ventura:       "1be537487a7c5e06b6294e7f0bdd909577be3ac20bc24f86a1492e5d141ca2dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94c8785d4558767d638fa87b3086a8f2aa43e223165c991e092e62a8106d2ba2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fn --version")
    system bin/"fn", "init", "--runtime", "go", "--name", "myfunc"
    assert_path_exists testpath/"func.go", "expected file func.go doesn't exist"
    assert_path_exists testpath/"func.yaml", "expected file func.yaml doesn't exist"
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
