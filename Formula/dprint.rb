class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.32.1.tar.gz"
  sha256 "ef81e5aa8365f46d1e9204e0fc45d8efcc8204620caaf491dfd189e1f2fb83b1"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a7fd00494bb0a3ab693e8ee75361ce65cec87a0d114089c9a5ce6ad32fdb1f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7f6c66d889f131170141788a32b51bdcd5704a0bb80d3c7df9039dc7e968351"
    sha256 cellar: :any_skip_relocation, monterey:       "f4c39043a962bd3f306ae9b17b031d1ad97da18aec79275daffb2ce74206538e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c266cdff0bad24fbc4af14b3d080dae321dc660279717696ede54c20c82b4b79"
    sha256 cellar: :any_skip_relocation, catalina:       "de262bb1351a98770592a57e15431e0500f28da6c21bbf01ea8ff008af038e99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "461d151f4a46dbad28be9aecc07fa14404f344c2cd63b924fd614f57d3d60cbc"
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
