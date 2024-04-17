class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.45.1.tar.gz"
  sha256 "a7bbec480c535f49b17ff01e02d384e27c09d28d5610f4112e562c3a4f2ce590"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db2daecc10ad06fd256b544af0103c76a4a360d1453b51f2f9b056efc1ab65b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6da0deb2a16fd7c72b19b0c673849f3d2e72d0a80c29bd171fbcaba7b9a62b2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07c567747f87e64c0b8563984fc7893101502284dd0151340a5c0563137a576c"
    sha256 cellar: :any_skip_relocation, sonoma:         "da14321779ced03ec7dad33fb63a4c13afcd4dd9b18671cf80578b61e947617b"
    sha256 cellar: :any_skip_relocation, ventura:        "79d784fc9c7b0264a28ac1bb36c9d7c8891b24c0674cab312d7412fa7e2a8ea8"
    sha256 cellar: :any_skip_relocation, monterey:       "4b4cc4102e88931c7503610bae06ad03ddd803f747854f45938dabe1886b2d02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a485e6999a1d01cd2d8e9ca653a7b89c4d39aeef3c88521ada3282cb84750e0a"
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
