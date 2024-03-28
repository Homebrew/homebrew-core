class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/refs/tags/0.6.30.tar.gz"
  sha256 "b562a1cf28eaa2f30b15f00502ce06f84c19f487af62f9ad4b64bb184942cd56"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "186eaeb05627f3992788b6499aee18e0cde118f6f4f54f189f17dbf828fd4eb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5e3097727477e4e8e172caa03d820dbf31f9f1f0df5c579fae0bf40f1e85b41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d09b02a2be5142bfc0ee79938f62375b7495eee63aef60cc8f55c065ac52b220"
    sha256 cellar: :any_skip_relocation, sonoma:         "12b6a48843c206f55c1940ba630aec93b4877114d90d193789a03eff327faf00"
    sha256 cellar: :any_skip_relocation, ventura:        "87bd1eb92051c7188971e8a5c295eca2e954d09b7d8730f25299dff048c5dcb3"
    sha256 cellar: :any_skip_relocation, monterey:       "48a9b449864f498d6e3aeed6d6c4ca750b348170eaba52d8f3ec8e6f7d10f68d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e934b8c4f555aba3791527f05770939f7928316fbbebf2f4276dc431555a1fb8"
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
