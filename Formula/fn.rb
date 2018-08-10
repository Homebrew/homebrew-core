class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.github.io"
  url "https://github.com/fnproject/cli/archive/0.4.143.tar.gz"
  sha256 "b716f79ecad44e1ee7742bd4a4ec5c3321578d32c7346e5a1d818c4383e9cfcc"

  bottle do
    cellar :any_skip_relocation
    sha256 "9dff0297c7956c7ccbac296f8db73d17b2fcdc97d31bf75fba3ad1a70f39ef13" => :high_sierra
    sha256 "ecfcf91b0260c61f8dda97f862c8bf8397dc00372eb6699891e32ae0347654d6" => :sierra
    sha256 "f64d75db709ac73be7c928af918ab1f3fb6b0d5106cb4d18ce15c833b8780738" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    # Remove once fixed, due to upstream incorrectly hardcoded version number.
    # See https://github.com/fnproject/cli/issues/376
    inreplace "config/version.go", "0.4.135", version

    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/fnproject/cli"
    dir.install Dir["*"]
    cd dir do
      system "dep", "ensure", "-vendor-only"
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
      ENV["FN_API_URL"] = "http://localhost:#{port}"
      ENV["FN_REGISTRY"] = "fnproject"
      expected = "/myfunc created with fnproject/myfunc"
      output = shell_output("#{bin}/fn create routes myapp myfunc fnproject/myfunc:0.0.1")
      assert_match expected, output.chomp
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
