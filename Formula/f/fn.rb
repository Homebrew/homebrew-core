class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/refs/tags/0.6.56.tar.gz"
  sha256 "0e93b7bffad494ad2d0201710bbfa8a941283c6f1051efa0b2075d788f3304c8"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0d81d297336abbacf2c24255a9aae787a821a80ed671e2c201842dd9d25642a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0d81d297336abbacf2c24255a9aae787a821a80ed671e2c201842dd9d25642a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0d81d297336abbacf2c24255a9aae787a821a80ed671e2c201842dd9d25642a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e8fc95897def1e1d1775e9f522457a9636d832dca9cb04cae346c497fcdeeed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f96be73d456be52568820d65d5939c787369881f02fdb944ae729db4e29a185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afd2b26ed581cab25e358b583306d9d59e36bcd062c15b9f3f43e64a33bff06d"
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
