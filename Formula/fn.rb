class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.6.14.tar.gz"
  sha256 "3f9c1cf9b7ae35a3157727b2dd4aeee7a1e67e2ccded824d9646fe92e77ccbd9"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73d9e99f87010815ed799a710d09a54f5a0fb1b11e84562f177587fbd130c4c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1f00fe0ff17acb527f37fefb172f367ef9fc5d0e264af5690be90ee8ce17cc2"
    sha256 cellar: :any_skip_relocation, monterey:       "db18d20e3040c0bbf0e23fcb85a19f2bc5eab53357c9dea17737bd640b769da6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7263f6be5883a0b5bfc7ec52768d6bfaf1d39f99f14a9dd765c608e558242eb2"
    sha256 cellar: :any_skip_relocation, catalina:       "ad053ab4be537fd7f650e87ddd399594297615d2e3e7b1b4360394358b7f72d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cca720737fdc492d6a91033b78dded9de7562a4a6b32e63d9b49ae40dfcf25d7"
  end

  depends_on "go" => :build

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
