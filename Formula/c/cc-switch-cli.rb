class CcSwitchCli < Formula
  desc "All-in-one assistant tool for Claude Code, Codex, Gemini, OpenCode and OpenClaw"
  homepage "https://github.com/SaladDay/cc-switch-cli"
  url "https://github.com/SaladDay/cc-switch-cli/archive/refs/tags/v5.9.0.tar.gz"
  sha256 "3894ef8811b6da912e406be9ae22ca84c970551aadd8d8d327ca62c2a3845f7f"
  license "MIT"
  head "https://github.com/SaladDay/cc-switch-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cad1c2a6b3f46c2da78e579f5f7e1911ee8826ae30293419134732435c246ad4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68d3e4567a525df928f2753443c0f337a265d1500a7149e54972facadad114bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0632930b6bfbb0998ea91cd7b4a0788fbbb4ea66418a57b5c10d3e4863844f56"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c3d0f51c524c1322a585f99ffbfcf53e5f076fcd401335d8ca30d1dea3a0a56"
    sha256 cellar: :any,                 arm64_linux:   "ef975bc5cf228aa2b7795b5091b9cf2c8b7e2698869ec5cf67125a44f922dd95"
    sha256 cellar: :any,                 x86_64_linux:  "fe137982383964d792179670fd8185768dcc9995f3d613de45e17bab253b08ce"
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
