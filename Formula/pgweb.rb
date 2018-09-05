class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/v0.9.12.tar.gz"
  sha256 "4c625bad8312dacf9bc9d64d40c2dea1e840175db9c60667a641c62289f9f174"

  bottle do
    cellar :any_skip_relocation
    sha256 "a71e56d151da1f158c24f669cfb44f03a7f2b80d8171e67e03e12bd8d1ddfa3e" => :mojave
    sha256 "31ef10e4430148ed0b70f32d1f6edf7c8741e02f4f2fbe21fd7c49783b3e0594" => :high_sierra
    sha256 "1f85f4bdf34399632b1a64a79ef39810909ba5faa3022def736caed9a898ff9a" => :sierra
    sha256 "640b9e3819d9915f00f39bb4319326a5d2f04ed75df4907f9a79db5231015812" => :el_capitan
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
        exec bin/"pgweb", "--listen=#{port}", "--skip-open"
      end
      sleep 2
      assert_match "pgweb", shell_output("curl http://localhost:#{port}")
    ensure
      Process.kill("TERM", pid)
    end
  end
end
