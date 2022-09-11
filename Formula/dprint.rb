class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.32.1.tar.gz"
  sha256 "ef81e5aa8365f46d1e9204e0fc45d8efcc8204620caaf491dfd189e1f2fb83b1"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e868a8ab537fb64b9b2d8bb357466541915fcb367af952b90a33171e635f190f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edd44c18b0cbb64beb94556f5ff7e11c4ec3eefe841c7123941ad04da9b419c8"
    sha256 cellar: :any_skip_relocation, monterey:       "cd37d8eac32935d4ecbf0b8f3e1b62f6d348291ecc6d1399c00aa0992933eded"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d6e972e9c17023ef60d69137db0e9b76df49c4ca9653278d8007955acf989cb"
    sha256 cellar: :any_skip_relocation, catalina:       "ef9a1d20adf4cf94770fd5869b4a950892e39a5777cbea164522d0d7587e3eca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd0a71f6c60959d340781e4ede72401dc60a87db6d290eba868039e8628e564a"
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
