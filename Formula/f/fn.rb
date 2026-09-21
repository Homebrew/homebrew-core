class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/refs/tags/0.6.67.tar.gz"
  sha256 "782d20fd52152ecd160f89286ee2e317c2602e3050d0f6d207f1ebe2bc241670"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "de4dfb3d9c3e116457c607a41e333b051d3834790f692b3ef832d2ed0b0534c0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "de4dfb3d9c3e116457c607a41e333b051d3834790f692b3ef832d2ed0b0534c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "de4dfb3d9c3e116457c607a41e333b051d3834790f692b3ef832d2ed0b0534c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7af687802711de7d3bf41e92b7afb886428314d5d01dd92840c705f003bc5a36"
    sha256 cellar: :any,                 x86_64_linux:      "25df6c15ab745a246dcbd50651c3306702c6aca598bbd596cc78408b1002ab7c"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
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
