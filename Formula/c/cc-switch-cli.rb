class CcSwitchCli < Formula
  desc "All-in-one assistant tool for Claude Code, Codex, Gemini, OpenCode and OpenClaw"
  homepage "https://github.com/SaladDay/cc-switch-cli"
  url "https://github.com/SaladDay/cc-switch-cli/archive/refs/tags/v5.10.5.tar.gz"
  sha256 "995bb09b38534659301d94ac675b7c7e2e860e3bf0ce41d5fc430c76b7b61c06"
  license "MIT"
  head "https://github.com/SaladDay/cc-switch-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "45979f75d90d7b2fe439a8efa98d614a18d640c7bbd29b7c55eec31999f70d70"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b7f8e7f73d944f44dffcc8ea5270a569795e2cb9ae17d39e88d4535d473685de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ed197b575770e17c7f401bdd8c8f18dfea6a358f5568431c7c78a2a796b4e52e"
    sha256 cellar: :any,                 arm64_linux:       "d754c27c274775cb072fbc22b87d2da089addbb9700b6e4b951dcd4677b98d00"
    sha256 cellar: :any,                 x86_64_linux:      "940452a43d25d2960a0539a5a89b25cc2eb4e88bb3fb5cfc6abb57c396d368a9"
  end

  depends_on "rust" => :build

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
