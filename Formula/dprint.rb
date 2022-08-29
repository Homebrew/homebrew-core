class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.31.1.tar.gz"
  sha256 "95fe041894fec8fb7241b189defb879ca6fc39d6aca49de33566620c05825692"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a034519f7bee3f403e9d087b2c3989efa92240c20b283a8c9a3fb435a185e51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d0ef65e7e2b36ad6f0b6d01e80e6a1fea1f51fa589083e85f542c103f79a18c"
    sha256 cellar: :any_skip_relocation, monterey:       "934abdf59f15c4fa2c48007d36fd0529300faa4a5eeb3448f27e9323400f6419"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d5b978204a48d50eff7d31a3c9b1509c007db631597acae3238b66b77831e12"
    sha256 cellar: :any_skip_relocation, catalina:       "f469e72e2737509c009e72a1b88e1d6455f7e023ebb1caf85fc1b4f8705a6380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52597aac1e79e541e8baf75d6460796a4ce7bfdde54338340e3976de5304c203"
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
