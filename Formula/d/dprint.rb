class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.46.2.tar.gz"
  sha256 "034d9462527ba26967f63977a0e50790ad90564d6a30288c8da92e6c5cf88f9d"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa70f3984978aeb6890b632f7173842de38ef65324678c51bec7b99c9322884c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbe2b7bf9ae0be288691f776f1b6f0e9d61b6717e8df6fa1ec8a330eb1d469f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15e800464b2a06ec15e0449cd0cdd423bb5fd5cad5014e11809c5fd344af0c48"
    sha256 cellar: :any_skip_relocation, sonoma:         "f71d3c1334611495d1275049547761409a921ff709cbd739f4094fccbb68f627"
    sha256 cellar: :any_skip_relocation, ventura:        "b3b75d8d55b15b46d746b852703f53d0ca3054d2c043f69491915e2c06460305"
    sha256 cellar: :any_skip_relocation, monterey:       "8baca843460034fd6a157ce37ff8ea296fdc2c901eb41188757998d0d2231eda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "338f0fc33d75433bea4a76b1e3bedd9ae45ea63a275dca1f7676b7197103333f"
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
