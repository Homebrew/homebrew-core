class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.github.io"
  url "https://github.com/fnproject/cli/archive/0.4.11.tar.gz"
  sha256 "adc39a305a22fccc356d2661b4878c7fe7c39153bc40b8693af580e01612873f"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f7c68826d6c0608b2e719f8a4380d87ac131b779e2a1904766aca61c5b3294d" => :high_sierra
    sha256 "6c6a1222ede1690975fa85a53995ffd3b541b5338fdd74bc1ee91f084d8a0aa8" => :sierra
    sha256 "fdfd2b1c6615bcafd6c6b0a2df42a87c88ae8283b15127214e8eda081fcc2299" => :el_capitan
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
