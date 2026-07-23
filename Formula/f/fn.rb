class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/refs/tags/0.6.62.tar.gz"
  sha256 "e55ff3e03442688076529e851ecc7a1c147bda400d025d76b8e451a2559fa730"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2ea1a0d4ffa8315cd4bdfcdaa927abbfe4094d0829338614f511921535f7535"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2ea1a0d4ffa8315cd4bdfcdaa927abbfe4094d0829338614f511921535f7535"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2ea1a0d4ffa8315cd4bdfcdaa927abbfe4094d0829338614f511921535f7535"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4b873fad17e5cd8b2cf91b5fe7e6ca6881bab6fd4ad182520c6a144ba5ec1f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baf49a681736a5dc32d226d3831889cb0b0471b7ba0de7440059a4dfaeaac107"
    sha256 cellar: :any,                 x86_64_linux:  "a36d0901912a24ba55e152f895e9dd03d435b469593c0338b1e5aeb7f1d5f1c6"
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
