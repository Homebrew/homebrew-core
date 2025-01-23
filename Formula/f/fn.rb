class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/refs/tags/0.6.36.tar.gz"
  sha256 "14f7ba45f9ed4a561ccdd52c45f25a1964093a326a6d7cc75b1d29e4f4f60c2c"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77836944153a672852e11a35fc5977cafc252a1917262309fb47ece9d8c75772"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77836944153a672852e11a35fc5977cafc252a1917262309fb47ece9d8c75772"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77836944153a672852e11a35fc5977cafc252a1917262309fb47ece9d8c75772"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7b09f2149d95e346fb9a86987516db8827d0cf1a0b61b205af7f1e4bfa3c06b"
    sha256 cellar: :any_skip_relocation, ventura:       "b7b09f2149d95e346fb9a86987516db8827d0cf1a0b61b205af7f1e4bfa3c06b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffcd70fab9ee15d9cad54a1932ce37b579193f273304f0ced02effa6e26d49e7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fn --version")
    system bin/"fn", "init", "--runtime", "go", "--name", "myfunc"
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
        socket.gets
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
