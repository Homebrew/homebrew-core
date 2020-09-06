class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  # Bumpable only when it doesn't use features only available in Rust Nightly.
  # Check for resolution of https://github.com/svenstaro/miniserve/issues/291.
  url "https://github.com/svenstaro/miniserve/archive/v0.8.0.tar.gz"
  sha256 "852542d1f1421c59d0addd5ed5371788f1095b89372ca5c6b293c69f570635f7"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8955f888b8c0828d741d5541a2ae6567704d78db99600d59b3d9a02dc571089" => :mojave
    sha256 "8711ae0bb727abd3ed3ad8d1335275d26fbc473f19bacfbad76b10b5a0bf4efc" => :high_sierra
    sha256 "a00b82cfce9fecd067b62ec3135a0e9cc59d3133f97ed3c0e7b815e4921c32d0" => :sierra
  end

  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
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
