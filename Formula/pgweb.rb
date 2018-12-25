class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/v0.11.0.tar.gz"
  sha256 "c3d73792a1deee527a4213e0b725a0caea8bb232c7e8e0a5162f2082bd86b368"

  bottle do
    cellar :any_skip_relocation
    sha256 "a56bc9ace9e4d640c8aceadf0887a242b3da59d7b5d75e71e4571d2280a835b1" => :mojave
    sha256 "d61b38c02fe2f99b0c34b1322a1abe5c7db9d9dc0f71e4c1c5901ea460a3b83e" => :high_sierra
    sha256 "b328036f921a983be2098f6ecb1dcf58f88ad1ec260859577d121cf0afea0f96" => :sierra
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
