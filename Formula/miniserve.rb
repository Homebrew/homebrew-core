class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.10.4.tar.gz"
  sha256 "03b8549258deb17759d69ad73047429f8420e3eab7588af086caf14e47c96332"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2f273329cfbbdee52d5846095079228e9a467928e05a43e2c15dffb9b46b0db" => :big_sur
    sha256 "b28e6374c318343d0118d62c780e3bfb51bc48044792f6ab85642deeba031b41" => :arm64_big_sur
    sha256 "379b4a5bbe9bf62605f5b34b4373e523136316caa6df0879ba27bbc30a512ce6" => :catalina
    sha256 "0b3ea752c7a77684ec37b9b30f2000e52b0e978ed8a0b2aaacc4ad927a614eef" => :mojave
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
