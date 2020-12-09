class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.6.1.tar.gz"
  sha256 "31c35c8e73bcd45368c3d390297fb4fc076ccf819711d15a52a6fe21a2dd5f0f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d92f60ada54db09547f52fc0137c61d945763e33cd6af6498cbcb975c3808b7f" => :big_sur
    sha256 "7536dc069526aeb438c353e85c9adfe6dbcae5aa5935e6d9b1dece71107e1731" => :catalina
    sha256 "760d3f7a25e99ac6541b05f4c898c17480fd23f09f0b87abf2c43972a6dc9d30" => :mojave
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
