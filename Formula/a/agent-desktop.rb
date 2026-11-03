class AgentDesktop < Formula
  desc "Native desktop automation CLI for AI agents"
  homepage "https://agent-browser.dev/desktop"
  url "https://github.com/vercel-labs/agent-desktop/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "5def2c52dc1e484920f6175eedaf4051dab4855f1a0c1b6148aeb560116d1296"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7d8e613996a758e2c0859b7deb673e9f02e5031e04c7f0e95b10ae997e2e4e87"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6a75a7504b10be829feb8a7dafef8f7f69f47e86a898523bbd4dc52eb33d678e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "99f856d02784ace3ecc8258f2de01c655e6e7ac2438c7aac542edfba884dcb99"
    sha256 cellar: :any,                 arm64_linux:       "789ec8832b29e116be5ac9420213801d337b788931013845ecfd1b8d991a322c"
    sha256 cellar: :any,                 x86_64_linux:      "2b4f2166bf10ccb0c47631a9a271f6b2c2a1f4014f4b1380bbf401c7ee3aeb22"
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
