class CcSwitchCli < Formula
  desc "All-in-one assistant tool for Claude Code, Codex, Gemini, OpenCode and OpenClaw"
  homepage "https://github.com/SaladDay/cc-switch-cli"
  url "https://github.com/SaladDay/cc-switch-cli/archive/refs/tags/v5.10.2.tar.gz"
  sha256 "19fc8e84ea324616662c607bf5ec432cc40e7e0356388dc0062cbda56c4c63ab"
  license "MIT"
  head "https://github.com/SaladDay/cc-switch-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78dbe14141e8c587f438cab6cded0a7c95e067efaee28bc689e0dbb688b67cd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcfdf099c39f8f63d37a5c889b26ed68ec0b05436a62af2a8f3e0f6df7fc7aba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ebeda8dc97def142053717efc574ece8c43f1708de2fa86b281f62d32c0deb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "730f38bd38815799a2ab851981b86bab6a6d10e386259feda5dc2f69e5d65652"
    sha256 cellar: :any,                 arm64_linux:   "fd205a0ae85e7cd744517e1e965c5eac1187a09b4b7f051bd1bc6308b0d499b2"
    sha256 cellar: :any,                 x86_64_linux:  "9fc263e95dfca6059664f1f65c9d20ca76b8bf254beae1011a96f7d2e90bfa8b"
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
