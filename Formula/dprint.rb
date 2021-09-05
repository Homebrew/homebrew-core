class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.17.0.tar.gz"
  sha256 "0b101fb8ca3d1a22fdb588fd7f7f5b02409b74e70289267634d7ad220d95523a"
  license "MIT"
  head "https://github.com/dprint/dprint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e443e56c929447d37abf7fec89385ac968ada27aa595b65a4fca3f6ba1f40d8a"
    sha256 cellar: :any_skip_relocation, big_sur:       "6e23aeb4e01df99e34ae9bea82baf3709d0d59dc98eca9c141b0bb2cc02cb540"
    sha256 cellar: :any_skip_relocation, catalina:      "cf837085135fd75ae9b68dc33e9d3cc1d22a6d48a2fdaab2d3357e09e1dcc34c"
    sha256 cellar: :any_skip_relocation, mojave:        "bec59454529a57475adeb2bd024db3e164ea7b548f113048d44556aa5062bd01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5d4f3fbb5074e73060277b91311a04a65f002ba5d5aa1fdb332ed478df11161"
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
