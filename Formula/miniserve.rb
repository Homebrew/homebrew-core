class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.5.0.tar.gz"
  sha256 "5b7c91bdf35e1a17ca006efa0354712301886c5c50952a2162401aef77faced0"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "eceff95e8228988815a3946130f3bdb62efc2a65213a9c2866f408755fda7910" => :catalina
    sha256 "0191163688b41dbe508ecd78334a7c07ca008a56dd593d4388a295721c56bdc9" => :mojave
    sha256 "8728bf2170cbc7f4c09800166c6017d6132ccabb59a3a7696d656852698acdb5" => :high_sierra
    sha256 "c5807a45746f591af319ac13b183ba674e98b8f4c8d0e8c9858c0cb88c4192f5" => :sierra
  end

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
