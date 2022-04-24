class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.27.0.tar.gz"
  sha256 "5b3761312a3ada13166ec598f83f0b67a2230d0145390c179b8ed558b8c919f4"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04813681b958f915b85229beb974033950c4a3075d368db7393d7a835d41bdfd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4e0d2fcd1b865315f7008ec46f6fe335b46d4e04689439410d959bffb7a3204"
    sha256 cellar: :any_skip_relocation, monterey:       "b5b189e990fe7e021f674cfe9f3dabd4c9e4afd9ee11f450603cd768dafcb468"
    sha256 cellar: :any_skip_relocation, big_sur:        "020f53e2aef1cd59af27368218691b27584018ae3db84a0d74982c725da87f11"
    sha256 cellar: :any_skip_relocation, catalina:       "20972d61c77bfc7c63c22dd080cb9c2ee537221450bbd0084d938240e9643e10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7050ecaef50ba7a82935bdea2d1889fd61f251f2dd30ceae0c2fbe2956a14606"
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
