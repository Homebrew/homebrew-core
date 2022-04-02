class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.24.3.tar.gz"
  sha256 "e9398ab6c68c08e8a271f4208ad3ba95930a79847c91ad4b113f4e43a0c1986c"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "253d08f07f9cfdd8251d328fe6db6d9157a7b0800942f5b8ac4c05781c3fc41e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc067b99731c5a8aab60f55ec1af46a5efe9da0a3a850ae898dede03585d5082"
    sha256 cellar: :any_skip_relocation, monterey:       "d5573fa4c0a12eb08cfe3ecf6323ade522ab4d01f55eca80fe3924ce9d2d0e37"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0330695a8b03cf54c6d615477d17aed80180cd25a22820242b37580e7fa8d1e"
    sha256 cellar: :any_skip_relocation, catalina:       "f3425af774df1dc5d761eb7eca594c078806aa07567af25c7cfaf2048c547743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9131b827372a524a7b141720908edac8911fcd6f6e076bf6120a411791bcf413"
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
