class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.6.20.tar.gz"
  sha256 "6a1555e31f1403744248eeb1eb07631ec322cfc9594bba8a4e031b381592b9d0"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70e980b7318a4512a47d59bae1115b65132b564cd955af33aeeb642df165d584"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "395fcc168ecdf5a0b72575a1481eff34d5ea5d7918ed287c2ed47138bfb61ab9"
    sha256 cellar: :any_skip_relocation, monterey:       "c87f98ed1402e9da8933805ddb02477827493003aa132ec4b49a8afa4da1986a"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd663d8190f7f4287c82c846e0756ddc093470cfe65113d05b64cabfed511002"
    sha256 cellar: :any_skip_relocation, catalina:       "36dc09ae38ebf9f338b122cbb983532ae16609468ac22ca6042f9edcdc1aedf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c42971e597e3eadbc2010bd5b1969e24fd13e12a56538ef44b201414bd386c1"
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
