class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.6.17.tar.gz"
  sha256 "7fbad5f089aa083aa3d2ab891cc1754457d3a0ccad2ed1e91af40f1ac5d6a110"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "267799d6b927ebe87b5c4c49e44a5cf45cc5ca85c99a1671503244a17904ecb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ea254f393e0fd4ee703a50afd897f3c69ed01f00e5be3525d493d70d4fbd54f"
    sha256 cellar: :any_skip_relocation, monterey:       "8f9262756f3be90ad340812de24a8a309a5e4d4bc846b5e42b00b1e2860631bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "41a148bff4a79248318b84787e5a5271678939a3bea271fb468fe0e0f426af05"
    sha256 cellar: :any_skip_relocation, catalina:       "fa050aaacccba7ed6aa1e15f75aadd9a3d686234cfef03569ee763f1dad667d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c0163c108f2ca39f7b0709f4c54cd687d02d8ab9ddbfe82e8739f0e232498e2"
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
