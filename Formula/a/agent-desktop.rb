class AgentDesktop < Formula
  desc "Native desktop automation CLI for AI agents"
  homepage "https://agent-browser.dev/desktop"
  url "https://github.com/vercel-labs/agent-desktop/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "93279668481f398f4f6a21e24fca1541f9840c3a74e0006f1279963256207853"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "55bd34970f363c12c04e16d8f39032040885b871cb13a673bf7033760bb6829f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5bcce6993d1c0bb929e97c40f475afe4b6e5ac49555253e2104ce160a2602420"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "62d166d75f7050bb93d4f26d7125004f53a26598b5126e1c64b0add27ab5ad8c"
    sha256 cellar: :any,                 arm64_linux:       "95597971213e520c0a013fdf83b8f57d5857eb121b6197335d6360c744b56807"
    sha256 cellar: :any,                 x86_64_linux:      "326485d1498e7a9826cafef502898369e68e1e7064858d3a04feeed65d9e1066"
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
