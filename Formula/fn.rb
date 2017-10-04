class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.github.io"
  url "https://github.com/fnproject/cli/archive/0.4.6.tar.gz"
  sha256 "e95c941aa5921d4a13058d8bbf99aad42fee82e8bb2e046a6de4315c64435d1d"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8c02720b927d0fb64f8a6d0c1ab7ecc018453e1e4b2c3198a5eb5455951cbf8" => :high_sierra
    sha256 "87809b11e1b7cc226c9e41e98952c375b54023d182750edb3b0ee5be8ee0cd34" => :sierra
    sha256 "cdf044aa28f027b9ff648cb810420c316bd548e7af4896d02414efa562926b98" => :el_capitan
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
