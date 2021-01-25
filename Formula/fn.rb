class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.6.1.tar.gz"
  sha256 "31c35c8e73bcd45368c3d390297fb4fc076ccf819711d15a52a6fe21a2dd5f0f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e493bdbe2d7f61000f4d92602789fd47850eb2c5f27be805888202880e81699b" => :big_sur
    sha256 "8d6ce96f1b90a20005b7676a71e9cca0219b9b10eb0141962b7862a16c90bf33" => :arm64_big_sur
    sha256 "deca08e83d8ff598ca73c0ef3fcf396f6ad20ec936c10bd0e2032595a0106d55" => :catalina
    sha256 "0bf5ce388e4c03334fec85b0b9733d9b270d38c8650223b591805c4bb3950b84" => :mojave
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
