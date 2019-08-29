class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.5.0.tar.gz"
  sha256 "5b7c91bdf35e1a17ca006efa0354712301886c5c50952a2162401aef77faced0"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "48938437585dac734e14af73c235da6a6c16d96186cfbe9be8c18d40c11d76d9" => :mojave
    sha256 "23fe1a66372f48f3db122f7cb5a6cde3201da294ee75d87dc887c6c9e1803a33" => :high_sierra
    sha256 "b21ba4b456e9f97d37c6fe667a6fdfb6d40c6b345c8f2a9baf0f85eb9cc39d98" => :sierra
  end

  depends_on "openssl@1.1"

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
