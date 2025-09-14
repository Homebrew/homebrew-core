class ChiselTunnel < Formula
  desc "Fast TCP/UDP tunnel over HTTP"
  homepage "https://github.com/jpillora/chisel"
  url "https://github.com/jpillora/chisel/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "0ec189888eda10ec606dd948965910df9e5374ca8378f772bc2f56fccbbc7dee"
  license "MIT"
  head "https://github.com/jpillora/chisel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1049f3436fb444ec030a3a72bd683e4b1f4b5b03792614f4fcc1e8c0102f97fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1049f3436fb444ec030a3a72bd683e4b1f4b5b03792614f4fcc1e8c0102f97fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1049f3436fb444ec030a3a72bd683e4b1f4b5b03792614f4fcc1e8c0102f97fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "59ba4b6702799362ee29fc43ff40979b5b8ee6c3836836140030c58a9a4c0f57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d85453104389b9aebc1f6e4f500f1a45529cbef269dada0afef991d4d69ad59a"
  end

  depends_on "go" => :build

  conflicts_with "chisel", because: "both install `chisel` binaries"
  conflicts_with "foundry", because: "both install `chisel` binaries"

  def install
    ldflags = "-s -w -X github.com/jpillora/chisel/share.BuildVersion=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"chisel")
  end

  test do
    _, write = IO.pipe
    server_port = free_port

    server_pid = fork do
      exec "#{bin}/chisel server -p #{server_port}", out: write, err: write
    end

    sleep 2

    begin
      assert_match "Connected", shell_output("curl -v 127.0.0.1:#{server_port} 2>&1")
    ensure
      Process.kill("TERM", server_pid)
      Process.wait(server_pid)
    end
  end
end
