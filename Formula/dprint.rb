class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.23.1.tar.gz"
  sha256 "b8f3304e572831055642daac225e85f2495e7ab55c3316945a55d2d842bb48dc"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6491dd0b1bb35887c68aaae5ef9354a5d37a356a8bca6345887e59b0e867c77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bcb50120c88b9e9e1425112e4c1183c6ea6248ef75deceb70f49061d03aecd4"
    sha256 cellar: :any_skip_relocation, monterey:       "caba8f092cd0d2a75d3b77fc9d24134f161896cdcb6a8573d0766e2a8079dc71"
    sha256 cellar: :any_skip_relocation, big_sur:        "db38752fab0b99183e1b772ce7083fdd3957d0ca39ba0f9e9815f30de6152598"
    sha256 cellar: :any_skip_relocation, catalina:       "1c043089f693e4ec1ac7760f6915b62bde2ef134b757627f26ec7b8c8d20ad7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d910289e3c2ec6338cb3e18024aee2430e0f18a1e9cae198a64b3fd9bc954468"
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
