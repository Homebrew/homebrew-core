class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.5.30.tar.gz"
  sha256 "14e5beab82a031bdf6f7b203e006f01f4f957eb05dde591095cf53f58a01b8fd"

  bottle do
    cellar :any_skip_relocation
    sha256 "8fb5937c03bab597fa6a3e8923ab3e4ebcf3cdbb0a7052c4a4ba6cbf6bff99df" => :mojave
    sha256 "b2bfd2adfeca65e82b5c8cdb56d0fb5c23dc4391a76699e3ba832ed460030ab8" => :high_sierra
    sha256 "8620b44fab2e6c767f7605e0cb8eb5172272fd2a8f80ca66df20a33e7d896710" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/fnproject/cli"
    dir.install Dir["*"]
    cd dir do
      system "dep", "ensure", "-vendor-only"
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
