class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.18.0.tar.gz"
  sha256 "5e0a44b0c46915d91eb1bc6e6d68f72bd3d90a39875a9368f9d39b27a3feb161"
  license "MIT"
  head "https://github.com/dprint/dprint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aa4a0351e231b77e798187a782591a4850bf65b09b72c792741b6b0c30509f45"
    sha256 cellar: :any_skip_relocation, big_sur:       "20a2a3adeb2c6b6a6951b145625a058340d417ee7740895e331bb31452d26fb0"
    sha256 cellar: :any_skip_relocation, catalina:      "d468b108fd3eb9d644f885e6f7deb2fcc5024798bca1a98e9fc305c16b2af31e"
    sha256 cellar: :any_skip_relocation, mojave:        "116ae7dd4bec8f15e0875757b2435fea69d7f5ce69e6e1b62e53da4d9d5e6ed0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bbb5deca311422571a8dba759d94c75ab76e7631430a5e2524562e8bf3b1ae4"
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
