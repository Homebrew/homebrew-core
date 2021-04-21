class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.6.6.tar.gz"
  sha256 "5197345f6708641d780875cc376d48f38e2d2a03a8fcabc018b011586cc54bf8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2b0305043276f90806ba994318a3103bf5b8901c2171ee659f34fa1f73e0270a"
    sha256 cellar: :any_skip_relocation, big_sur:       "bbfa43d414d85de6e2aad105e3652a743a7cd0a5a16709ac33bf55bb579ccc2a"
    sha256 cellar: :any_skip_relocation, catalina:      "4a7a42140245f5ee06e6e7fba77f52754ebb1c92aa1d1ac2563cfb335f43936b"
    sha256 cellar: :any_skip_relocation, mojave:        "140adc5aa8ee9f15de3fb6918e2342f703c711043b68b38806bed3efbe07d2ec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", "#{bin}/fn"
    prefix.install_metafiles
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
