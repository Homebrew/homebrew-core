class CcSwitchCli < Formula
  desc "All-in-one assistant tool for Claude Code, Codex, Gemini, OpenCode and OpenClaw"
  homepage "https://github.com/SaladDay/cc-switch-cli"
  url "https://github.com/SaladDay/cc-switch-cli/archive/refs/tags/v5.11.4.tar.gz"
  sha256 "927e28a95d1d9e63849b0591d29171f095dd812abf64241e91e0fc1db440d24b"
  license "MIT"
  head "https://github.com/SaladDay/cc-switch-cli.git", branch: "main"

  bottle do
    manifest_sha256 "8ef14b20cd2f20b7646587ba356642b9e55e5b624472b79edb4179a23747157a"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1ec3117ebf4ed1868851ceb64b8a77a8c386a5a75697ac63607bb89b57a6d416"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d52b56d0d32ab018bb5b0ec6b38a25bbc16be34bafc34c7eec51043375b89f6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f2ee6b8cf8417a982f1c990004cbdeb368bf0acb13bab1e4a4e12f146a0b31d6"
    sha256 cellar: :any,                 arm64_linux:       "42a721fdd4cc4014000e81eb3d6f76c46d4dc54fedf486cba2507f5ce6a415f1"
    sha256 cellar: :any,                 x86_64_linux:      "8c3211596ee16c01d0a276787b4c7add6a4bc620b76eddc0a0e470dec0c94438"
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
