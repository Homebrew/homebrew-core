class AgentDesktop < Formula
  desc "Native desktop automation CLI for AI agents"
  homepage "https://agent-browser.dev/desktop"
  url "https://github.com/vercel-labs/agent-desktop/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "348e47e890a331dd3da04de526708e042f2cdea620c448540ecd8d91656d5177"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "45b6e2dd181e84fed8496a72690cc15c558ef121a4dc98f47c025762df68ecfd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f3aed9a9db71e7208f28f447905cfae61302b46f44b1f92e1acbfbd578024c2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "367f5693e0a12df939ec8c4b56150bd72b32eb074b0bc306f2b9d9568ff33610"
    sha256 cellar: :any,                 arm64_linux:       "de0d456b08e672096db82492badcdd19aed3bb42a4ffa666e72772b783009520"
    sha256 cellar: :any,                 x86_64_linux:      "9d9ba2708f69c14b7ed1218dbecb26056d8a049e4d8d0e1995cab7548fc12723"
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
