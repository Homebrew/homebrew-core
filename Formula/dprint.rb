class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.17.3.tar.gz"
  sha256 "9f407722bf48742dbcd0e7e6b4abad46a66a3de3c9055ae1471d4e121df2274d"
  license "MIT"
  head "https://github.com/dprint/dprint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1ff7ec7b2c58f64a1870b56790cb7f4a2b886efefd99257b16de24b5abb062b4"
    sha256 cellar: :any_skip_relocation, big_sur:       "3fa9c531e87046fe8e271984c9010c9d077d48b37eecc9fa659b612176fc3233"
    sha256 cellar: :any_skip_relocation, catalina:      "b07135b5c5cf0cfeaca1e0ed4646ad5f901bd60d6717a01ecad3576d24ba2d8f"
    sha256 cellar: :any_skip_relocation, mojave:        "361999b49deb85b38221d12698933aa0ea52e30e753f0254a86477c1bd8e432b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebe54dbf2cade7955742e3df7f1c96692aa9432ad6607e80839bcec8ec3f3a5d"
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
