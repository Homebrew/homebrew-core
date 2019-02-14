class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/v0.11.1.tar.gz"
  sha256 "a4de020f1c68f9d26983f93d12cff992db318695d14bcaff51211a5fb761987f"

  bottle do
    cellar :any_skip_relocation
    sha256 "d4327a28c76f7b0f67f1e78a2dfb9a6f42918874befafc9a39ad2f631dc80dab" => :mojave
    sha256 "cfe2c7d43a29b4b587a0e99dd2b9642e7cc5b1f68ca714270a5f0aa28fd04dd5" => :high_sierra
    sha256 "d69f1702642a18897ac21f4af7e4ff0e11c8698f5a612212e1e452f56b8aae25" => :sierra
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
