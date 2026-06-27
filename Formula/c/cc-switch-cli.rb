class CcSwitchCli < Formula
  desc "All-in-one assistant tool for Claude Code, Codex, Gemini, OpenCode and OpenClaw"
  homepage "https://github.com/SaladDay/cc-switch-cli"
  url "https://github.com/SaladDay/cc-switch-cli/archive/refs/tags/v5.8.5.tar.gz"
  sha256 "6aca4a27b203d59b3ff2243455e6f552e2c67be8da871a22bedf2b211d350fcc"
  license "MIT"
  head "https://github.com/SaladDay/cc-switch-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6019e1f6ff8565bd44274d6889ed749fe5186dcc7c2b73ab1fe272f3e29aeac6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6c8a9f7120942b80fbff6ab5f14f3e0d83627359b81f184de35c509863e138b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ed7327d933a7fbb84fcbdf07d7bd7d6cb6d3019c58c81dbbc479b26b323f5c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a053acab59e582c22829611ae931fc0972ba57c49e5af5b5037efab09a8fdda9"
    sha256 cellar: :any,                 arm64_linux:   "1a0d274d19761e656e79031ba321ecdb03d940c4c217a268535e4b626d1e0702"
    sha256 cellar: :any,                 x86_64_linux:  "8e80b06a0d6c31b33899ccbb5dec535556c606ca54088a7f0d8a7a064c4d8467"
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
