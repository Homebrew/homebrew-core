class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "b65580574ca624072b1a94d59ebf201ab664eacacb46a5043ef7b81ebb538f80"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e88ed7a4692ef71f8756e12c6ee5ffacd3eabf49e46921c168d82457991f1b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43d1b1d6b117bf724e90ab833d44bb292010437de66941beb60cb106c55f3b08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a38b42d03092adc1f76c24ce2427558ffb095c4311b27dc91e0e83bc8cc9828b"
    sha256 cellar: :any_skip_relocation, sonoma:         "22f0b5f3b4a3e8bb50951a6e15715847e1b2e60a97042be536f2ebeaa1e235ab"
    sha256 cellar: :any_skip_relocation, ventura:        "46cc01f37e9ce86f6cb36cab4ef6616c7dd4d112505702ec83b3f0532171ac46"
    sha256 cellar: :any_skip_relocation, monterey:       "58cbc71a43994a41cfd1cf78ad0cb2ca0d308a7a1618c6659c519f09433dae34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2808c4c82f492fc736ba467d978e78ce3bfb5c61ad3da0e4cb394e98243243e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"miniserve", "--print-completions")
    (man1/"miniserve.1").write Utils.safe_popen_read(bin/"miniserve", "--print-manpage")
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
