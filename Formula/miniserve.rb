class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.13.0.tar.gz"
  sha256 "3578fd2dfe8dbebecd15b1e82cfb6d6656fed5e54ae4fccc4e7a6879b61dd1e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ab0f48f372b54392e6b83e71f830d988e0137db522011635a843039745e5d694"
    sha256 cellar: :any_skip_relocation, big_sur:       "a8cbe41787db5cde1a0b47a4e67cb1f8d97eac9d64cf8270206e36541c504630"
    sha256 cellar: :any_skip_relocation, catalina:      "241d099eb1913e5ee44a5f7f69dfd7d67a2953672438ab87f3f3b378c81f4ea4"
    sha256 cellar: :any_skip_relocation, mojave:        "4b9ac6c29ca4d042f195d45934994a7d7a74c897324f4ca4ba17dda1601301f9"
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
