class AgentDesktop < Formula
  desc "Native desktop automation CLI for AI agents"
  homepage "https://agent-browser.dev/desktop"
  url "https://github.com/vercel-labs/agent-desktop/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "348e47e890a331dd3da04de526708e042f2cdea620c448540ecd8d91656d5177"
  license "Apache-2.0"

  depends_on "rust" => :build

  deny_network_access! [:postinstall, :test]

  def install
    system "cargo", "install", *std_cargo_args(path: "src")
    platform = OS.mac? ? "macos" : "linux"
    system "cargo", "install", *std_cargo_args(path: "crates/#{platform}")
  end

  test do
    output = JSON.parse(shell_output("#{bin}/agent-desktop version"))
    assert_equal version.to_s, output.fetch("data").fetch("version")

    output = JSON.parse(shell_output("#{bin}/agent-desktop skills get desktop"))
    assert_equal "agent-desktop", output.fetch("data").fetch("skill")
    assert_match "snapshot", output.fetch("data").fetch("content")

    helper = OS.mac? ? "agent-desktop-macos-helper" : "agent-desktop-linux-clipboard-owner"
    assert_predicate bin/helper, :executable?
  end
end
