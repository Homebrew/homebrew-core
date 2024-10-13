class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.47.2.tar.gz"
  sha256 "b4d6b87d8177c2ec0a88e33e5cf08802e2ca15011f2933e18e2165556e63ed5b"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "77b18f5e225bd8495676f3cdbe7a3b38c9daef349560a1d57deeca8ed9b0709c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5fdb1701c7431880a29ad56aec15221be3c798a7d6351df4d828872b4b6be436"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8b8473a4ab554e15a746691bffc2b619a5d9002c51003f4c233ecc41a3fe4a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5e7102a16180f6ec2bb6a4be4b8c95db66b687fd7a5d74a4a26486a893d4a89"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba3badf93b7ec4fb7c4b8e5523235f8738761936458c1f6be3321151c3a33a12"
    sha256 cellar: :any_skip_relocation, ventura:        "c24a3c232bef52927607d46a1aafccaad43e72dcfe827cb26d3a04e1a663239d"
    sha256 cellar: :any_skip_relocation, monterey:       "1c6df1164434f895f7d7636a57f5e2b49e45473175dc96d07b337c5151974c92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4977100b3b463db1083ed431c0fdc1045030d494d0a488e32daf3e79d7803b65"
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
