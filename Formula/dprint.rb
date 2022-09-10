class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.32.0.tar.gz"
  sha256 "5a250a246a72d8d856a1e02d0acebea45356b39ac3d06bc5101a261ebe44bbf1"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e66e41e474cab896dc6f5489683d16283e836d1c7b7abfc95dde0406baf1969"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1de0e67330c87448e700857b3eb75170f5f2be8a30b9907dd21ee19a571b2afb"
    sha256 cellar: :any_skip_relocation, monterey:       "19bdbddd64b39cf5b74f5cb48a3b11ca6a6b84d4090adff85d4986300518f291"
    sha256 cellar: :any_skip_relocation, big_sur:        "20c38ff77d9e0f02011650ef1a7c668e5a951d9fa459483d68037944e3edb9c6"
    sha256 cellar: :any_skip_relocation, catalina:       "a33d3255a22a68a3d0dfe0e1494c28ecc41eddd64ae2ff45da7e6f44e4e0f575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc2b5e0e77677100bcebf9d6a2a16da84342a2883bc6f453359465459e863e8e"
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
