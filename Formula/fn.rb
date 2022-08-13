class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.6.22.tar.gz"
  sha256 "40581ee36aed8c570ce5dff63ac3dc291b5c0c17dcb92ded54626157d9db702b"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5421d5d17008f4875e0ad4d668c8577e4fbf099361448fea87693e9ebef625c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4df8321d69f919d23372426207b07fce0e702e8fa6d34014347cfdc121277d20"
    sha256 cellar: :any_skip_relocation, monterey:       "80db7dacc20937b4a32a46718a85d57f13468467bf4e1b3e4b4ccb86d1ca6faf"
    sha256 cellar: :any_skip_relocation, big_sur:        "5903e71285bdbe6076501bce58562eb902dfa0371b19b196be021407182ef430"
    sha256 cellar: :any_skip_relocation, catalina:       "67b518b567ea6a5b00d068693f6efb3b4aad5839296633e9124f5470ff15c657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac6f652d760870c91e44ce718cff8a08d43315f9c7f42e9de5c422109563602e"
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
