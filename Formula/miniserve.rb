class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.6.0.tar.gz"
  sha256 "cad2608ff5459e5497b73b6b8635b76b0c38ce0bcee24bf4f2192984f386de93"

  bottle do
    cellar :any_skip_relocation
    sha256 "534cd0d7b79d8c06a5246a3d11dfb0fbbaac5aad634922883ebfd5fe958b2711" => :catalina
    sha256 "b150191be231782aec0a73ed3a83245de22eedf9682ace58532d67857c042f47" => :mojave
    sha256 "ccae720adeff3ef96f858a1709657c9a1608fd7a86689f9947174824cf9a4081" => :high_sierra
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
