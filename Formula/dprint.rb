class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.24.1.tar.gz"
  sha256 "13319b0f925d4eb5134d1a4d22ed15f0b188b254de2a1efdc3e15a5250dbbd43"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05856adf05092cbeb048aa5fa46f01af40eb4cee8e21913a009c49a34c562010"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06c7d438c87e5e06b351b0c48bf333206c6c782e3bac1445909c616705ed8851"
    sha256 cellar: :any_skip_relocation, monterey:       "fd6f79106bb640e5f49665893d3b0e8ee7a32b3aeefbc4866991cce5c29c3f2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9e9e96335f809e86c3c33412135fc8886ed7af6ef3cbdd28476337db3088ffa"
    sha256 cellar: :any_skip_relocation, catalina:       "6045ee177aedfadb8b53613da9d91f94af6b7a44adca6d87c9789c6bddccc59a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ae93fc4123419ac8e45275c5ef37715c4487d7a5dc19437e20914a75a2c0d03"
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
