class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.21.2.tar.gz"
  sha256 "f83edb7f6c68509880c6a73187b66b288ae17441d031aa4d256131216290710b"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17e71f4024d07600cf2f3973a49396125fae83f01caccac18ae6319309161085"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2d1ffda4811485861f53a31e5fc16da47b13521be04e6d3a2921866b9a8918a"
    sha256 cellar: :any_skip_relocation, monterey:       "3db8ee58b7619597db16b52dfd6a861bc81749aa2a165de59c0eadf0560a575c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6271d83e5437548aa7c9064b24a5cc1830d20a54d5d39ba2567be9769381e2a"
    sha256 cellar: :any_skip_relocation, catalina:       "6c6da33b86545e82e68e45d5ccb7ee5e2d23e148e7947ef4bdb83ecccd2923bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db79a47230230f542d047dcd7aa9abb1930d10ab84b4585951ac78c82421f275"
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
