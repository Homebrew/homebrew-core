class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.5.88.tar.gz"
  sha256 "3e33cd4b69001a7d7cd161d9e862a2194f0c6fd4ca44cd93c9ac4407e07dc089"

  bottle do
    cellar :any_skip_relocation
    sha256 "f36e1fa20f332836e3eef50af10baa94d475c39159e36f06224d119e9aa1a351" => :mojave
    sha256 "ab8ad2e0acbd775d4a7dd88c052db3fd0aa6461e9ee2deaa6adfcfb2dbbeb48c" => :high_sierra
    sha256 "8cb3db24db02ff7b8eb9d1adb69a35d9e00081aabb84698e69ff01786dcb36d2" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/fnproject/cli"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-o", "#{bin}/fn"
      prefix.install_metafiles
    end
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
        response = '{"id":"01CQNY9PADNG8G00GZJ000000A","name":"myapp","created_at":"2018-09-18T08:56:08.269Z","updated_at":"2018-09-18T08:56:08.269Z"}'
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
