class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.11.0.tar.gz"
  sha256 "f81bd7ceb269c9358bdb09e11a731781d1a84d17c9f01e80b1bdbaf3ef1c90f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b28e6374c318343d0118d62c780e3bfb51bc48044792f6ab85642deeba031b41"
    sha256 cellar: :any_skip_relocation, big_sur:       "b2f273329cfbbdee52d5846095079228e9a467928e05a43e2c15dffb9b46b0db"
    sha256 cellar: :any_skip_relocation, catalina:      "379b4a5bbe9bf62605f5b34b4373e523136316caa6df0879ba27bbc30a512ce6"
    sha256 cellar: :any_skip_relocation, mojave:        "0b3ea752c7a77684ec37b9b30f2000e52b0e978ed8a0b2aaacc4ad927a614eef"
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
