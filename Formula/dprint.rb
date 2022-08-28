class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.31.0.tar.gz"
  sha256 "cb977a4769d0083d06357d6d9773d1d37f4c279a785b4bab20bdfc25152cc884"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c65fecfdc588d545dc8e86cc86de0ff9af5992644d4823f3ace948eed528ef3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "248e2feee964ddb72a26457aa192297892299ba8c55417e429423b6f665d3441"
    sha256 cellar: :any_skip_relocation, monterey:       "e3efec3f357ccca33eee6c3619e658d4d3717d84b5259092b0dd7bc0ad6ebc45"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e4496e57cb7a93f4440fcb340dd075c0d32a2440f627754dd66376763e14dcb"
    sha256 cellar: :any_skip_relocation, catalina:       "eb9880921a78031d1b215bb4f7e884c8ee789b9ca64b74ae01ff8ea1e62c37b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bb8d945418901efbb667c5837dfef368587889f1949d1e30937aadaeed889b9"
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
