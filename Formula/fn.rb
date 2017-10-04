class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.github.io"
  url "https://github.com/fnproject/cli/archive/0.4.6.tar.gz"
  sha256 "e95c941aa5921d4a13058d8bbf99aad42fee82e8bb2e046a6de4315c64435d1d"

  bottle do
    cellar :any_skip_relocation
    sha256 "00f0c8f87d8c17c39af8128f682da627747a43b1743f0a5554567688c5b557de" => :sierra
    sha256 "3c6be9d67ca670a02e797e1c33f964844a2872b09a34e8ee79c02f323c5a7801" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    dir = buildpath/"src/github.com/fnproject/cli"
    dir.install Dir["*"]
    cd dir do
      system "glide", "install", "-v", "--force", "--skip-test"
      system "go", "build", "-o", "#{bin}/fn"
      prefix.install_metafiles
    end
  end

  test do
    require "socket"
    assert_match version.to_s, shell_output("#{bin}/fn --version")
    system "#{bin}/fn", "init", "--runtime", "go", "--name", "myfunc"
    assert_predicate testpath/"func.go", :exist?, "expected file func.go doesn't exist"
    assert_predicate testpath/"func.yaml", :exist?, "expected file func.yaml doesn't exist"
    server = TCPServer.new("localhost", 0)
    port = server.addr[1]
    pid = fork do
      loop do
        socket = server.accept
        response = '{"route": {"path": "/myfunc", "image": "fnproject/myfunc"} }'
        socket.print "HTTP/1.1 200 OK\r\n" \
                    "Content-Length: #{response.bytesize}\r\n" \
                    "Connection: close\r\n"
        socket.print "\r\n"
        socket.print response
        socket.close
      end
    end
    begin
      ENV["API_URL"] = "http://localhost:#{port}"
      ENV["FN_REGISTRY"] = "fnproject"
      expected = "/myfunc created with fnproject/myfunc"
      output = shell_output("#{bin}/fn routes create myapp myfunc")
      assert_match expected, output.chomp
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
