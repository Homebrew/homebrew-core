class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.5.94.tar.gz"
  sha256 "c6f75ee7d25f1f451f5f9abab01a8099789de89d76cf9bf9a8da1549281c3b89"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e3b5fc8d155764ec247bb8f1ec687a83f064e1a17d9b1f7a69474f6a1febb5e" => :catalina
    sha256 "7e8e45718bc849d03c7250d2388b48c7ee976215fea9a317aa14f6c9433e646c" => :mojave
    sha256 "f65593204275c1417081ba5854ebccadc2b499742590ccff0d8261e3e3b14f2d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", "#{bin}/fn"
    prefix.install_metafiles
  end

  test do
    require "socket"
    assert_match version.to_s, shell_output("#{bin}/fn --version")
    system "#{bin}/fn", "init", "--runtime", "go", "--name", "myfunc"
    assert_predicate testpath/"func.go", :exist?, "expected file func.go doesn't exist"
    assert_predicate testpath/"func.yaml", :exist?, "expected file func.yaml doesn't exist"
    server = TCPServer.new("localhost", 0)
    port = server.addr[1]
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
