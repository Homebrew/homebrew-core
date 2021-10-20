class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.6.10.tar.gz"
  sha256 "700f8c16418380653cf3b0cb8b7e7ff31c023f228b60fe76e166ef5a2c738818"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ed2dabc37263cd236ba9f23dfd9b97caba9c3e754fecdf2114c29c511212a27c"
    sha256 cellar: :any_skip_relocation, big_sur:       "7f998d561dd3c2c308d68bb1aca9b57ee4e47740414f1293addfc439515062cf"
    sha256 cellar: :any_skip_relocation, catalina:      "e860f2c2fa289281fe1f87eadad62a900a0bb2626f9b699b29722793855fd8c7"
    sha256 cellar: :any_skip_relocation, mojave:        "d2aca33ee6a1d067ff8a6b5cadf6ee30b81dc5022ad3a6ea92fa1e0ceb3011ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac0076f80d160802f731adc61eb207bc46096be4cf07ace3292e696943568443"
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
        response = {
          id:         "01CQNY9PADNG8G00GZJ000000A",
          name:       "myapp",
          created_at: "2018-09-18T08:56:08.269Z",
          updated_at: "2018-09-18T08:56:08.269Z",
        }.to_json

        socket = server.accept
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
