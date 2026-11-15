class CcSwitchCli < Formula
  desc "All-in-one assistant tool for Claude Code, Codex, Gemini, OpenCode and OpenClaw"
  homepage "https://github.com/SaladDay/cc-switch-cli"
  url "https://github.com/SaladDay/cc-switch-cli/archive/refs/tags/v5.11.3.tar.gz"
  sha256 "e54d386336e91200161b701d31c6877a20cb0c5a3bcfd6da8b8036523c805c76"
  license "MIT"
  head "https://github.com/SaladDay/cc-switch-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "458daeee5440181db109864c1e09c8b7192c168b5f2da81eb701396bce67a9dd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "de0cd8038b87a36795e56ed5e3d8f2d739416193a01f522914cd834c133074bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fe523d4a824ca2d2b7c3bc9a4ab597fe683a53335936125378f1e4d826adc35a"
    sha256 cellar: :any,                 arm64_linux:       "88a48a8416861bbf21ad16d211105f8986931daef5d3e0009398a64aba4dadf1"
    sha256 cellar: :any,                 x86_64_linux:      "96c3912398c1f2115909fd1eaee67b0d5a3de103cc9c4a4442cde880e4758509"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "src-tauri/Cargo.toml"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "src-tauri")
    generate_completions_from_executable(bin/"cc-switch", "completions")
  end

  test do
    ENV["HOME"] = testpath.to_s
    ENV["XDG_CONFIG_HOME"] = (testpath/".config").to_s
    ENV["CODEX_HOME"] = (testpath/".codex").to_s
    ENV["CC_SWITCH_CONFIG_DIR"] = (testpath/"cc-switch").to_s
    ENV["ANTHROPIC_API_KEY"] = "cc-switch-test-api-key"
    ENV["CC_SWITCH_BREW_TEST"] = "1"

    output = shell_output("#{bin}/cc-switch env check -a claude")
    assert_match "ANTHROPIC_API_KEY", output
    assert_match "cc-switch-test-api-key", output
    assert_match "conflict", output
  end
end
