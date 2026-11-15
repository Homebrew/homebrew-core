class AgentDesktop < Formula
  desc "Native desktop automation CLI for AI agents"
  homepage "https://agent-browser.dev/desktop"
  url "https://github.com/vercel-labs/agent-desktop/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "29d53d959b15e424821f164e81381e3e81f7ced5790ab841141c3bad10478524"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9dc1cf64a9eac593da931ce813b7668bbfd8793fc0e048cee3f2e72ce80ba540"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3312ebd3ff27c5428207e886c4bb6c09307e23639658cba2880bde7bcb52caee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e3a43949e76cd4bfb74e4f285663d23c11f06a89d3e7f7b7764d8d4207fcc729"
    sha256 cellar: :any,                 arm64_linux:       "de63bf03312ebf7a208b5e83bec7e4cac0116493aadc1aef6145614de0082078"
    sha256 cellar: :any,                 x86_64_linux:      "d21e67dbfc0b975f9abc49000d4376725425c3c164a9cf839f201f7cd0fc0138"
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
