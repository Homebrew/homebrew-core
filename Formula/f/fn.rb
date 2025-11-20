class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/refs/tags/0.6.47.tar.gz"
  sha256 "e37d18c23b80c056b7a5f1b099e01083b21a838abefd3e171b3938b8472bb73b"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94af73ca6b7489d4806f17cd64da2b2b9ec99e02958cf5b67a8be08222dea3fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94af73ca6b7489d4806f17cd64da2b2b9ec99e02958cf5b67a8be08222dea3fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94af73ca6b7489d4806f17cd64da2b2b9ec99e02958cf5b67a8be08222dea3fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "4005a0cc233f7595f0ddeb1dcf6d93f77b47cea77aff37cc106a3a9af8f21839"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e58ba3db85ae4e30055f92ad28f17b3d782efb214826023211ba7b43542be60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afb29e58d848e0fa086b079318e3eff7e5450170af4de4c22ec57636d0e7ee04"
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
