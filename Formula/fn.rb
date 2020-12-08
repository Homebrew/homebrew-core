class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.6.0.tar.gz"
  sha256 "2c345fb866e9cda443089d84595c87851e292605f4a0f71c16147727f0c3de4e"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c71cb42d008f663f57588b8b9379aeaa9944ad9173a12cc58cba7f83dbaf5f8d" => :big_sur
    sha256 "582d8a1bd26240a5b9832dd229af100639c03c752e40f224b23f80ccfe9db36f" => :catalina
    sha256 "5528881001e7df693778ff794d430c45b3b1180a52f9fd422a73b1a29850d9f3" => :mojave
    sha256 "1548f6ce7b1c2624084719b1eed4f6b8eaf6946c7a4c0a47a97aafab61d6c153" => :high_sierra
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
