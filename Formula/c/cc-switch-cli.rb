class CcSwitchCli < Formula
  desc "All-in-one assistant tool for Claude Code, Codex, Gemini, OpenCode and OpenClaw"
  homepage "https://github.com/SaladDay/cc-switch-cli"
  url "https://github.com/SaladDay/cc-switch-cli/archive/refs/tags/v5.11.2.tar.gz"
  sha256 "ebf5e0e7e8aa65ba68c1c5b062c2162a897d05b4bc917961bd1a2bdf27d36902"
  license "MIT"
  head "https://github.com/SaladDay/cc-switch-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d46a311d2ba81e97301caf5ea00bcd811dfbd61e50e1dc59de1f31b1b66bf0c2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "61c5f66a0fb1a8af19cbb55db89529cf9aac98f7d8a563b1aebebeef7326cee2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "08addc8c8f598ce8c32de40f8248e2c1249eacf13646d930acd35430a7d9c0a1"
    sha256 cellar: :any,                 arm64_linux:       "aec0d7f55839a147257cb2d9c2877a7fecbf3395407c568812a20aa6e789168e"
    sha256 cellar: :any,                 x86_64_linux:      "a298706b4609dfe4041e7b2a50c9a5eaa678ebd490282d41ad98a442d9810909"
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
