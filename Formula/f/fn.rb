class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/refs/tags/0.6.60.tar.gz"
  sha256 "d614fd3d6e2a741d416e8fec752f1c5f9961208fae546f30b688f5fb2ebc2fc6"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "645df28f810cdac3e31df511670e240b5e27cd3cb2d460d8e721b9502cae3632"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "645df28f810cdac3e31df511670e240b5e27cd3cb2d460d8e721b9502cae3632"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "645df28f810cdac3e31df511670e240b5e27cd3cb2d460d8e721b9502cae3632"
    sha256 cellar: :any_skip_relocation, sonoma:        "819c1fe550394a806dfaa8681726a5f63585218fe9d234f37b5b0c018bdc8c85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ce455d010d527b8b66eb3b4ea0fe3d33f23ff02bbd21a1a4523c9a7e07690d6"
    sha256 cellar: :any,                 x86_64_linux:  "5d5a00ee519572666e534b7f3846418e923233aebeb450ed9a37c67d41438854"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fn --version")
    system bin/"fn", "init", "--runtime", "go", "--name", "myfunc"
    assert_path_exists testpath/"func.go", "expected file func.go doesn't exist"
    assert_path_exists testpath/"func.yaml", "expected file func.yaml doesn't exist"
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
