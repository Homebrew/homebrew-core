class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.11.0.tar.gz"
  sha256 "f81bd7ceb269c9358bdb09e11a731781d1a84d17c9f01e80b1bdbaf3ef1c90f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "916cb032415cf9a92f99714535774592c1adb2e6b01aea36c28d60d3e910b909"
    sha256 cellar: :any_skip_relocation, big_sur:       "4195e1a7576a43bc2bf6accc959a81e1349cd8b4c6e28c3344616ea9ade1f1a8"
    sha256 cellar: :any_skip_relocation, catalina:      "3e67b2ffa1b6ffda5adc32278fb7c9109202c49e2c9bf4537fe6bdb7237d1dfe"
    sha256 cellar: :any_skip_relocation, mojave:        "26a6f26ac6dbdf86e9e5950accf6393c1a65c5baf310c387cee96e10389f627d"
  end

  depends_on "rust" => :build

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
