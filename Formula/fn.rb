class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.6.11.tar.gz"
  sha256 "872ea9b7a93bb4ffd47defe4023aebc5c57b3f1db2d601dbb60ef42aad0c780b"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31137e821a4d8a2547cdb83089834252ce72c02ca48502b02fc0793e4bfad455"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85d676b361a17ee6208184d8a4ec0305497f118f85a84ee7c682d23d58baa740"
    sha256 cellar: :any_skip_relocation, monterey:       "c4c87002dd9354584de4cea3cd6a27abc4d5357389b701ad66373f83342f0eb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd951aac2ea949487262df0ed02c76509a6c845fdc154ac11abf169a8c22d080"
    sha256 cellar: :any_skip_relocation, catalina:       "c2b5b4aa1a0a4bde889dc666d8b11c1a4835834de0e90a9622708ad283f04b67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "453835cb778d2604c4dab50c6a99f8a1a3578dfd26d510d619902ba45460e660"
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
