class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.19.1.tar.gz"
  sha256 "c4019e8d0fd5301bc2752ebc7dfea10de7410f77ce8c74e2ac5a7a0eafcd3772"
  license "MIT"
  head "https://github.com/dprint/dprint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83f6ce5ccfc0b4f9fd2acf8a3851724c473a5be4aefc96b035c73877292b1f18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5762c44fbcd619b3f4bf1433d81fe832b137953171fbbf15d2d6fd00505ddad4"
    sha256 cellar: :any_skip_relocation, monterey:       "f7c3aba22efc307aa5acf1a57c07535cdb94500d97e3a3f7d96c0285fdbf4fdd"
    sha256 cellar: :any_skip_relocation, big_sur:        "3455fa678ea12f1e261106d452f7010b6b630f6e296360e1a1c0c1466c4b2100"
    sha256 cellar: :any_skip_relocation, catalina:       "a563464d98464550db326452d722399391a816fbe7a8c9052030ffb1ca97bcac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a688cc66f9ceb1553d3bf3d13763138d56e2adfec3d28f140be2a2d780aacf93"
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
