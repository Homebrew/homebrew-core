class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.6.12.tar.gz"
  sha256 "7ede2ea39e97b711c44bd203db785fff136f0f1737c924b24dd5a31b2e14c46c"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13e139ced94f4ae21389442a48eeaa95e8eb1a301fd48a4de8b20ac3ead132bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3292d372217803403d702abcf327483fadb0075112540eb44a937ca92390cc8"
    sha256 cellar: :any_skip_relocation, monterey:       "85297567de5152119682831de6c7e066ece30e3b7e77752e3a188368e736aba1"
    sha256 cellar: :any_skip_relocation, big_sur:        "3333ac345f2d61b6dc661bc218961bb63cdf7073c830ff8f468352d22b27cb5f"
    sha256 cellar: :any_skip_relocation, catalina:       "7909974b7a60fae000a5abe9b6eb4978072ed20bb5578278e1417a44aca0a678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1514e2c0c45f6c2cddcf51ec79b1c1933d0b18c3f4173b865e829ba220f5318a"
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
