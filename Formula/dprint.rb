class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.34.5.tar.gz"
  sha256 "e0980db9f4003823b99b1b9a17f460f71ce55bffaddfba80c5f00e0492746e00"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2408616b511a24e1b7024b758528b4c96a009dc4474e48681b230032c638246a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ad080b50794097d03696b8dda870a7db3b0c6e7798790666946e861ae03a38f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2af35bcaa0221f2f3a785c6d0075f0a624ccf1c896dc6ac3d827c58300867f42"
    sha256 cellar: :any_skip_relocation, ventura:        "f924b1244181578f547745405e9b6419f91d91f3a66fbcbcb6d7f81596e2a815"
    sha256 cellar: :any_skip_relocation, monterey:       "eaf33914416852bf4297606dfc810eaf809bb7baec2e8200836b8b9c4139ff5f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f353a6609c84ab6c21628ba0efb3fefe227e0a58cb41a4b8b9183c7a2445fc6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cda7bf0439fd0362c994d505170ee26a449d5a3345786c5edbcb3b87166101a"
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
