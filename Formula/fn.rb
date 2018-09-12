class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.4.160.tar.gz"
  sha256 "e704abb29f4c3ac0b375a1482b04be934595a09618528cf7669014fb21bb8c8a"

  bottle do
    cellar :any_skip_relocation
    sha256 "180e8c667ad053b2c05a8314ef1b4d9d9d5b8239e2f28ed88f96897f0a92d5bf" => :mojave
    sha256 "debb3aa6a0953083afd794e7e0e3a8f21ac2be7fd49167664ea9348221c4a905" => :high_sierra
    sha256 "2f1a8785734b729300a12c480d427b65d42304c2ce4d4c171d2faa9282015d9d" => :sierra
    sha256 "5a5c3a5ceba73b5033213ab06f9df0b019566a8c98274b14e454bf9780dbc11a" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
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
