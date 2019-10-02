class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.5.90.tar.gz"
  sha256 "7904d530797bcd2411bf4b7074cb081264f5a6ed8dad44825aca55a95ccb38c5"

  bottle do
    cellar :any_skip_relocation
    sha256 "f2db1a901cefc4c0d30fc3c7c7bce08ac902dc2550bfbccd8e1a7c77498fff5c" => :catalina
    sha256 "98fb3a3d307bfff13f1e0c92b02e1ddc05fa5c33576cfd876465c2175f677381" => :mojave
    sha256 "775c187a1d3e74f9bde27b8cdc07491f97746aa10df5a4ed6d1b2a90810d1cca" => :high_sierra
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
