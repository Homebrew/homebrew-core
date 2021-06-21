class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.6.8.tar.gz"
  sha256 "eebfc7bea0da0f56cbe392c0dc62b35804f6531ba9dd6b49ddf4875f32505fae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cdece231a93d918679aff4365e28abf13eff116ee213692568daa40d95bd3e99"
    sha256 cellar: :any_skip_relocation, big_sur:       "05f4afa0bbd454765bfdd652a31ee80b8064fe57c7d1812a1f9c7ac2da990e73"
    sha256 cellar: :any_skip_relocation, catalina:      "8fa84327394e057c668906bf33d799f59510410e49da51b218e88e09820a3607"
    sha256 cellar: :any_skip_relocation, mojave:        "df350eb2238e4ec8a17a446639ebdca3fc2275678f72702db8c3795527bc6ca4"
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
        socket = server.accept
        response =
          '{"id":"01CQNY9PADNG8G00GZJ000000A","name":"myapp",' \
           '"created_at":"2018-09-18T08:56:08.269Z","updated_at":"2018-09-18T08:56:08.269Z"}'
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
