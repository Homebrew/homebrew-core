class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/refs/tags/0.6.33.tar.gz"
  sha256 "e2fac541b77211451c343af90dd9a3adb3b8127b030a4c8659b3f5b76fb1517e"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35d1fbcedbb4c530b2ca27ddb30b055b2b5c308ea99bbc6c7c2630807c7bee72"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d52f67663f4f4d31edb8380964bc9edbf5c6e7dc301c9b49585c9b1bd41f6714"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a75f7e3ce4fce03862b2d713b820f58e3c24fdb9f4dc82c5b198a9af43556adc"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd678a3e620f132c1790a624ac92b21dd8065d5f4cc365dc43a11b9d9275a1f1"
    sha256 cellar: :any_skip_relocation, ventura:        "dcf6f5377b6c21e44163c3af4e0c6f3e5ec38a72262d2bace9eecedb510f75d5"
    sha256 cellar: :any_skip_relocation, monterey:       "be30610e7fe3309013637ec7e01f729767afdc269e0c49f4ec69a3942a361b33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a4a164d472becd4522918fd8de86152e43550e56b274365481547cc9deedbda"
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
