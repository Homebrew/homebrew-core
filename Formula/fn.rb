class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.6.23.tar.gz"
  sha256 "1f34eb5c1c43759a4d5a4de01fe850ade410a1b4c4e7d4d51e23910e2f978854"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "459e3ccc7de4bb49f8e901fcd27a14cfd41e754d6867fc694124bf1038b7d657"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5a73a2c61a782c491c472eef535f660d7eddfef12d788d4c644ae040eb4e013"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7e5fac2037ebf083c484554a1aca56729b9a631e5e6db8cd2e0930e1179d708"
    sha256 cellar: :any_skip_relocation, ventura:        "abcd61b594b462e75305596a99635b21545121e1221a5c78d527d93f3f43c905"
    sha256 cellar: :any_skip_relocation, monterey:       "81ea4ec3ababd3e8f3473ee9876d5d360835352ccf969751b5fef9afc0946b21"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec596a172d47796de2f76d1cbf45c844e791ee468fdf198e4e83eefea35ebeb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e38836cae152077e69d2ddd9e232ab2f3a5b9e3bd3140a4c6cc83d1f7f3c6555"
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
