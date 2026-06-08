class CcSwitchCli < Formula
  desc "All-in-one assistant tool for Claude Code, Codex, Gemini, OpenCode and OpenClaw"
  homepage "https://github.com/SaladDay/cc-switch-cli"
  url "https://github.com/SaladDay/cc-switch-cli/archive/refs/tags/v5.8.1.tar.gz"
  sha256 "cf168a872af3edd9b9866e82a33f8382ae2ff428383f8954ec9f7a2722d3217c"
  license "MIT"
  head "https://github.com/SaladDay/cc-switch-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b8e0978ebb929d538d3f7c097708d538323694ca267cdeb2e2a253b8abb5253"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a97639e17f61be61a02ea8e4e5cd70b76e7e5cf2af96d18ca95b66a8ff90765b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0dcaae7865e5f2125cecb090c146345581381d1fdb58bba086a7aecdc2732d40"
    sha256 cellar: :any_skip_relocation, sonoma:        "61cb68980dd1ce84938ea5a0dad29a7649f2fe22620e71b3547268c530ff10c3"
    sha256 cellar: :any,                 arm64_linux:   "ef0020a9ff981b20b433c8c422e9d11139052185488fe776bb5f5d894be5f80e"
    sha256 cellar: :any,                 x86_64_linux:  "da49101f9ac95d855c3b00ba327245e829a50772d212a693e15963e1e7f3e3eb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "src-tauri")
    generate_completions_from_executable(bin/"cc-switch", "completions", shells: [:bash, :zsh, :fish])
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
