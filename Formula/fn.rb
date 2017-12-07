class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.github.io"
  url "https://github.com/fnproject/cli/archive/0.4.27.tar.gz"
  sha256 "5487f0fd4ea27be206474d0ba3f63bf93a8ccc3aad62cabd12a19c2cb89875f2"

  bottle do
    cellar :any_skip_relocation
    sha256 "c74f8a79921d7765d577a67ba5da7b3a7198b9d1d3d383e1bcb160734b979b6c" => :high_sierra
    sha256 "7429c5a029d511228787138769aac4327c7db13b25934012eb5f0e77996da8f9" => :sierra
    sha256 "b725e25e8d6840d8db45059e4ecdc57b20e064686986a1a95990dffcaaa5c6b3" => :el_capitan
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
      ENV["FN_API_URL"] = "http://localhost:#{port}"
      ENV["FN_REGISTRY"] = "fnproject"
      expected = "/myfunc created with fnproject/myfunc"
      output = shell_output("#{bin}/fn routes create myapp myfunc --image fnproject/myfunc:0.0.1")
      assert_match expected, output.chomp
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
