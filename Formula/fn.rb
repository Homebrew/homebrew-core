class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.6.14.tar.gz"
  sha256 "3f9c1cf9b7ae35a3157727b2dd4aeee7a1e67e2ccded824d9646fe92e77ccbd9"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66f0ee5a858fd45315cee2f349801053f815308d09e43d3810f318f9aaec9988"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eff4e23a9c6c8c3ada8492430cb3c509a843ee5defdb7cfd26f95ff065d64f9b"
    sha256 cellar: :any_skip_relocation, monterey:       "5f48e64d4cd7e3e7151267254de4f8a31fedab3e537916f18b5e1ac0e332e393"
    sha256 cellar: :any_skip_relocation, big_sur:        "a70f793707845cdb9b89a68cb0c6ddcfe7cb4fc5a8201cf2a9a8481e824942c1"
    sha256 cellar: :any_skip_relocation, catalina:       "64548a23e8d0c393fb3259d5b20b5d965ed558a600b2fa124b5b911ea47d1236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75747402ee1afd4881479b96866606cc1e7915bd8f8196c6687a281eb99f32ad"
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
