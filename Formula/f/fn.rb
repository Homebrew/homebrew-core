class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/refs/tags/0.6.53.tar.gz"
  sha256 "24d8d6378801c8cbb584112f11c050bdec1707d392e705c100dcdac2ebe5c1e2"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8946b5650a0c1af12ce716b865bcc1839482a86e4f5769f3d1542dab7818be16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8946b5650a0c1af12ce716b865bcc1839482a86e4f5769f3d1542dab7818be16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8946b5650a0c1af12ce716b865bcc1839482a86e4f5769f3d1542dab7818be16"
    sha256 cellar: :any_skip_relocation, sonoma:        "c32e439bbfc090357664bbeedeca39ee154171337ec367fe22544b113de301ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a604d4c65e1793c2e529122d6ad118baf51cde573ae8bb9fb9c72a11f8833df4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "888687eb322a8b398b49026144e96daf4cbafd5dcc656ae16d1796e834dd4270"
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
