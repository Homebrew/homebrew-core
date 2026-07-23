class ChiselTunnel < Formula
  desc "Fast TCP/UDP tunnel over HTTP"
  homepage "https://github.com/jpillora/chisel"
  url "https://github.com/jpillora/chisel/archive/refs/tags/v1.11.8.tar.gz"
  sha256 "219764707ae7356f900a3b8e4b87041779a6fe0967cf6ea1d67b89c2a0741743"
  license "MIT"
  head "https://github.com/jpillora/chisel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "493587cceebb65dd5690cd136d0743fd188acd8ea3dc24a341a1aa4fd3107831"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "493587cceebb65dd5690cd136d0743fd188acd8ea3dc24a341a1aa4fd3107831"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "493587cceebb65dd5690cd136d0743fd188acd8ea3dc24a341a1aa4fd3107831"
    sha256 cellar: :any_skip_relocation, sonoma:        "57fb22e6af19a3e5ec3646ff47e74e706ca97fb402402fbb61c9d33c416c2ad1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27b12464e4dc6acde91d5de201edd5fed14784cd90e0df1b6a7922cc5e5eb32a"
    sha256 cellar: :any,                 x86_64_linux:  "7dc4654594b977b65691855b2cc1ddd475f6f1112d028fea02f5039cb4face45"
  end

  depends_on "go" => :build

  conflicts_with "chisel", because: "both install `chisel` binaries"
  conflicts_with "foundry", because: "both install `chisel` binaries"

  def install
    ldflags = "-s -w -X github.com/jpillora/chisel/share.BuildVersion=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"chisel")
  end

  test do
    server_port = free_port
    server_pid = spawn bin/"chisel", "server", "-p", server_port.to_s, [:out, :err] => File::NULL

    begin
      sleep 2
      assert_match "Connected", shell_output("curl -v 127.0.0.1:#{server_port} 2>&1")
    ensure
      Process.kill("TERM", server_pid)
      Process.wait(server_pid)
    end
  end
end
