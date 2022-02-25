class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.23.0.tar.gz"
  sha256 "b45a447aca887e458ad01719fa1dd04ba1b862fa58b7d1c1a81f0dc63519a39c"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e58265d0e2d5022f376c7af7653b547c386232442c3d792a4e233250ab1d011f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a7087f7691b873ffea47eff81974ad6c8913cfc57b67a26bc6e4a5a1d320b6b"
    sha256 cellar: :any_skip_relocation, monterey:       "3e6305d797046d0491a177b80e9ac7954469f743156872aebfda947b97ace145"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc8fae1347c1253ac867483c3e861de3922447bc2962671834ea3b6ea64de864"
    sha256 cellar: :any_skip_relocation, catalina:       "4ac22c552d94674527c7864790489558a6df78753412d870ef5499c1b1179356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "031a9e26207079ba0fb7cb6ab48f807b389b1c48bc5ba6807948b17b45a318af"
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
