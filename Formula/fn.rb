class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.6.25.tar.gz"
  sha256 "b9901163b3346dc985e24de08df65c9e70acdb128c359dd479df4e900aae3bfd"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2e9c993e9171346ab387523d81177d092c0142c27272fba23d4daa0761559e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2e9c993e9171346ab387523d81177d092c0142c27272fba23d4daa0761559e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2e9c993e9171346ab387523d81177d092c0142c27272fba23d4daa0761559e1"
    sha256 cellar: :any_skip_relocation, ventura:        "139fb4bcdd278ef2bc91b4b605a18f96549ce60b621b5d99139982fd9962e845"
    sha256 cellar: :any_skip_relocation, monterey:       "139fb4bcdd278ef2bc91b4b605a18f96549ce60b621b5d99139982fd9962e845"
    sha256 cellar: :any_skip_relocation, big_sur:        "139fb4bcdd278ef2bc91b4b605a18f96549ce60b621b5d99139982fd9962e845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d84528807591a1244af860cb3ef3161e312bfed4eba8b74ccd82d2cecd3894f6"
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
