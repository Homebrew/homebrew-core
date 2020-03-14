class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.6.0.tar.gz"
  sha256 "cad2608ff5459e5497b73b6b8635b76b0c38ce0bcee24bf4f2192984f386de93"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "82eca53aa5ca2e90b82bbce87ab964bae0e83b536ecf164a7f1c39a89571b855" => :catalina
    sha256 "3b2d47cf800219c31be4767036e8ddfc4dc6bf67793a24f3a7bc83710414cc84" => :mojave
    sha256 "076ced27fb5a0dccfcf1c6059675369360685ba2f939fd7fd70b775a33dfa863" => :high_sierra
  end

  # Miniserve requires a known-good Rust nightly release to use.
  resource "rust-nightly" do
    url "https://static.rust-lang.org/dist/2020-03-14/rust-nightly-x86_64-apple-darwin.tar.xz"
    sha256 "6cfe5b598502d4bc6afb1bec3b1e87306d3b4057ce1ffcd8a306817c2ff5fc87"
  end

  def install
    resource("rust-nightly").stage do
      system "./install.sh", "--prefix=#{buildpath}/rust-nightly"
      ENV.prepend_path "PATH", "#{buildpath}/rust-nightly/bin"
    end
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
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
