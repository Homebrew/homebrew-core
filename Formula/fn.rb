class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.6.17.tar.gz"
  sha256 "7fbad5f089aa083aa3d2ab891cc1754457d3a0ccad2ed1e91af40f1ac5d6a110"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b214e7720a89871595a60e2cdc4b665482703a2d84a6c0db24b3da11afb418f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e8ac0b59c6fa8b326f615a7b65b51412e25dce6753c21518fca303d10c100df"
    sha256 cellar: :any_skip_relocation, monterey:       "0ac7eb43fb5970f508c6a08931531a43b98ec71cbb1c7c0e57f593955fcbf31d"
    sha256 cellar: :any_skip_relocation, big_sur:        "586d50c1264743ff0751b0701bcbed5bbf7d15f341800d269d72a0bda13df2f9"
    sha256 cellar: :any_skip_relocation, catalina:       "5f25debf98810b71ac018e8968eb42bacc5173d901d3466f0b2992eadfcecc9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce05c3b7adbd1091fd356d74b6a38e4d97225e98e60df5f1fc918505a9a3c0c8"
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
