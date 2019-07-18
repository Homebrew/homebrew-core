class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.5.84.tar.gz"
  sha256 "143d836ffea499f0e98fc0c5c7da4b3a81e89545ba0be31ddbb03462b591e9d9"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b47dfba5554142157daa64a7b64f4945a9a95ce055dc5db669918a2f265b57c" => :mojave
    sha256 "dcce8beb0a0ba54ee309dba1f8eeddfa0100f45880400b3e227ebaef7e4c1c36" => :high_sierra
    sha256 "cfffcadc9ec536363287808fbc373baa9e8ff61d2832dd0e7e9d6250162f1a1a" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
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
