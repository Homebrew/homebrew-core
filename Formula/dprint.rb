class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.24.0.tar.gz"
  sha256 "490ae40a426d722178a18ee35b3e16cf376d19b31cd47a70a37871b667896dd3"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8820c7cd48ceddfe3f6b41e66ac95805b42c7f9de2f4eb677123385a8d46692"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1487452652ca3961e795cef6ed4173746d016cacbf094dd3dd08433700dcaa37"
    sha256 cellar: :any_skip_relocation, monterey:       "6c6489290fbf87b758b6abdaaa4fe2577ae95af9fb6e7c8251955cdefc761e43"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9a782fd8151a96f58d65882717de35b46fccaeb9bee1b36a3c7da3e24a6b457"
    sha256 cellar: :any_skip_relocation, catalina:       "0dff93f8c54652b463f306dae60a64de388927b14474d279716097d5a7f0357e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffbafda857295de35c6e5fce3322dd68c61c949bbd82e48bcf320acf78961edb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dprint")
  end

  test do
    (testpath/"dprint.json").write <<~EOS
      {
        "$schema": "https://dprint.dev/schemas/v0.json",
        "projectType": "openSource",
        "incremental": true,
        "typescript": {
        },
        "json": {
        },
        "markdown": {
        },
        "rustfmt": {
        },
        "includes": ["**/*.{ts,tsx,js,jsx,json,md,rs}"],
        "excludes": [
          "**/node_modules",
          "**/*-lock.json",
          "**/target"
        ],
        "plugins": [
          "https://plugins.dprint.dev/typescript-0.44.1.wasm",
          "https://plugins.dprint.dev/json-0.7.2.wasm",
          "https://plugins.dprint.dev/markdown-0.4.3.wasm",
          "https://plugins.dprint.dev/rustfmt-0.3.0.wasm"
        ]
      }
    EOS

    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"dprint", "fmt", testpath/"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath/"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}/dprint --version")
  end
end
