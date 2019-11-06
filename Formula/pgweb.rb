class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/v0.11.4.tar.gz"
  sha256 "1dc101abc31bc349a38b746b98835572498049d06b8be9938c795f89bbeac936"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce25f236df051d88022bdfa279d31eea35ea283fe50d73da64837e785d74b79c" => :catalina
    sha256 "a073f7b5f18ac4da86a16da5bbdb5e378691eb7f2167c8d6632d5f5e274f6f11" => :mojave
    sha256 "d2835f43238673d6df1fecdfa8a6688a808c6ecb1d2574f21966ab3cd4d8812f" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/sosedoff/pgweb").install buildpath.children

    cd "src/github.com/sosedoff/pgweb" do
      # Avoid running `go get`
      inreplace "Makefile", "go get", ""

      system "make", "build"
      bin.install "pgweb"
      prefix.install_metafiles
    end
  end

  test do
    require "socket"

    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

    begin
      pid = fork do
        exec bin/"pgweb", "--listen=#{port}",
                          "--skip-open",
                          "--sessions"
      end
      sleep 2
      assert_match "\"version\":\"#{version}\"", shell_output("curl http://localhost:#{port}/api/info")
    ensure
      Process.kill("TERM", pid)
    end
  end
end
