class AgentDesktop < Formula
  desc "Native desktop automation CLI for AI agents"
  homepage "https://agent-browser.dev/desktop"
  url "https://github.com/vercel-labs/agent-desktop/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "d6b5af85dc025bef4dfa8a7a16ae2e0271343d7d98e7e480bc9f74a4c831a783"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ffb3aaa08de557d63ede80a310289ed26c1174f2e69853ad05c366983ad60fdf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7fd4571195f3b2972034d0e6731066069d5bf6ffec7cd95521905ea0aac0ebd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3ac78589e133c32283767002cd535b2901e3fbeb3c2bdae15da603bbac8f1fb1"
    sha256 cellar: :any,                 arm64_linux:       "1cbf8a974a60e79b9c9f8a3abb0c2816afa616bc00895e4d2f3d88dfb3b19fa8"
    sha256 cellar: :any,                 x86_64_linux:      "8117c126e258365695f60a1b25f19b0996207ee366e8ce01133c7bc1e3f5217c"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "src")
    path = OS.mac? ? "crates/macos" : "crates/linux"
    system "cargo", "install", *std_cargo_args(path:)
  end

  test do
    output = JSON.parse(shell_output("#{bin}/agent-desktop version"))
    assert_equal version.to_s, output.dig("data", "version")

    output = JSON.parse(shell_output("#{bin}/agent-desktop skills get desktop"))["data"]
    assert_equal "agent-desktop", output["skill"]
    assert_match "snapshot", output["content"]
  end
end
