class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/v0.11.3.tar.gz"
  sha256 "6d9606ce5c609e774781f588e5802108abb6355f706b6245e26906521799d9e2"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8e7024aaee40bb2141b7ce7d3b03c161d938f744fbe8a8a50049cc80cf37ba3" => :mojave
    sha256 "56e54c598658c4cbc9e42104661bfb2cd36ac9c076aa4febae944f68eea60a9b" => :high_sierra
    sha256 "8184607026c1f3179f379b0c7d4050e4b3cba53e3aa9afdb906ae3b645663516" => :sierra
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
