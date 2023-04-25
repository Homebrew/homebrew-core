class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.36.0.tar.gz"
  sha256 "9fd1912b2d180febc89420724ce7fa31bbc5c0001e1560f94ce3c93d4f3c30d9"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b47134faeaa1fe3af41c8e1e26d18c0957c7d0fbc7583b4679a149542357de3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0482dedcff919ccf7e2b9c58cc711ffe1543817f896ec3b32c692de33e1eb0e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f17e0145e7dc71fa6dcb94a839a1036a80afd1cb73488abfadfb8f41c9ad7fc8"
    sha256 cellar: :any_skip_relocation, ventura:        "a76bbbe381ae38370156a3856a14a086a2c9531018f326b2872267c995e5242b"
    sha256 cellar: :any_skip_relocation, monterey:       "0e746d8c69ab12781eba10abfb16ec7fb9464b6d5239b18613b61290301a5877"
    sha256 cellar: :any_skip_relocation, big_sur:        "b643196be379017d2fd6222c058e513979ca8d5e6931815ee13ba7df7fbab51a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41994a70bd194b75479c2a1bb562fa7716755f3dc1a4eef7ed2dc5c4ca9e5cd4"
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
