class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.6.9.tar.gz"
  sha256 "77c7f52b595e53740ecc7f82e19ed0e66ea20267dd8957854d04605ad9540e3a"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ca67fb44b667930bedc4d70d479cf0898a2959411d72ef27df38e75ceb751cdf"
    sha256 cellar: :any_skip_relocation, big_sur:       "f9242da69c2ff818effdd57b29441c5b70f919e203fad4ac758d3d53f1368df9"
    sha256 cellar: :any_skip_relocation, catalina:      "a916fca3a10a3c67c970078901982bf8a9627b6125ae22830e3b093b8e202ddf"
    sha256 cellar: :any_skip_relocation, mojave:        "31b30385e76a5c3020487e583d1369b414633b038419fd96b43f395277efef8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0a90ba76f98db9f8b66786d61b7b7fe9ba53a58702eb91d3fdfb33c1e1f7dce"
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
