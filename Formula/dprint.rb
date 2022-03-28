class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.24.1.tar.gz"
  sha256 "13319b0f925d4eb5134d1a4d22ed15f0b188b254de2a1efdc3e15a5250dbbd43"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9e9b3e2fa7a3bfb2c1c1324ff84241daf5ca27bcc8aa4eaab911e16a77094e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac4d06320b92829ba382c914e9e6194fd66e609a73fa2a3ce359f10cbe4ff89c"
    sha256 cellar: :any_skip_relocation, monterey:       "b7392df5539e478d5667d8aff381d1c195dfb07ead2c10a41c46642fd984c622"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a0ea45c26bb14292e275663197accb1857b476cfb9753158d50168905faf194"
    sha256 cellar: :any_skip_relocation, catalina:       "acf60377ce17b4e2a9dcb7bd23398e403d630b74e1380cc06883b662efd85e04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05859dae4cf675cf3223cf6fedf5564f2a819e5d668f21186dd51472993fdf56"
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
