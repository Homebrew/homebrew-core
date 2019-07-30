class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/v0.11.3.tar.gz"
  sha256 "6d9606ce5c609e774781f588e5802108abb6355f706b6245e26906521799d9e2"

  bottle do
    cellar :any_skip_relocation
    sha256 "54d9b58164e36731378ca6bed6f5e78fc80a5484d598d5d6897927ccbb787fad" => :mojave
    sha256 "81b6f85babd2c22d092db1065e341c902834381d8e46583f1378c0d2974db062" => :high_sierra
    sha256 "effef44dd2f65ed0e24304aeb2be96529597f45d4beab80f74c11c4ee4a906a0" => :sierra
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
