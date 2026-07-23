class CcSwitchCli < Formula
  desc "All-in-one assistant tool for Claude Code, Codex, Gemini, OpenCode and OpenClaw"
  homepage "https://github.com/SaladDay/cc-switch-cli"
  url "https://github.com/SaladDay/cc-switch-cli/archive/refs/tags/v5.9.2.tar.gz"
  sha256 "89a15c882bc2f5bab1efe378c152e12a7cb1fe29cc3dd001f1e3373f20fddbf5"
  license "MIT"
  head "https://github.com/SaladDay/cc-switch-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42324b3b0ba52869ecea432e45ee23d1be741c69c27f2573b633b53fe80333e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c90ebcc578e0d01405918e2255bc512550edccf4c6ac905b6df027fb1b68711"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05f271ffbd2d9897e86b2d50f0e2ee3b0028eb9b02270609d2ee4357fa7ec953"
    sha256 cellar: :any_skip_relocation, sonoma:        "5499f7662a78299635f27ff51bc967e45b21b5aac0f38107b6302783179b587a"
    sha256 cellar: :any,                 arm64_linux:   "240d2a7f1aa8011d916a9e99896cd99b98841bd40d1d153bd112341c0bf3d3fb"
    sha256 cellar: :any,                 x86_64_linux:  "645f859dfc73bdb24f74a6781cdf84c456a68fa060d8ebf30488b5b0743762f1"
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
