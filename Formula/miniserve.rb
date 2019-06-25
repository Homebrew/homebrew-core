class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.5.0.tar.gz"
  sha256 "5b7c91bdf35e1a17ca006efa0354712301886c5c50952a2162401aef77faced0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8955f888b8c0828d741d5541a2ae6567704d78db99600d59b3d9a02dc571089" => :mojave
    sha256 "8711ae0bb727abd3ed3ad8d1335275d26fbc473f19bacfbad76b10b5a0bf4efc" => :high_sierra
    sha256 "a00b82cfce9fecd067b62ec3135a0e9cc59d3133f97ed3c0e7b815e4921c32d0" => :sierra
  end

  depends_on "openssl"

  # Miniserve requires a known-good Rust nightly release to use.
  resource "rust-nightly" do
    url "https://static.rust-lang.org/dist/2019-08-24/rust-nightly-x86_64-apple-darwin.tar.xz"
    sha256 "104ddea51b758f4962960097e9e0f3cabf2c671ec3148bc745344431bb93605d"
  end

  def install
    resource("rust-nightly").stage do
      system "./install.sh", "--prefix=#{buildpath}/rust-nightly"
      ENV.prepend_path "PATH", "#{buildpath}/rust-nightly/bin"
    end
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    require "socket"

    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

    pid = fork do
      exec "#{bin}/miniserve", "#{bin}/miniserve", "-i", "127.0.0.1", "--port", port.to_s
    end

    sleep 2

    begin
      read = (bin/"miniserve").read
      assert_equal read, shell_output("curl localhost:#{port}")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
