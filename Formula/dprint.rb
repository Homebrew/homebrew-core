class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.18.2.tar.gz"
  sha256 "162dade20c396ba33f5d3530daf8d2d3cb62916481cc69e40e5f60534508ba46"
  license "MIT"
  head "https://github.com/dprint/dprint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c507dc7c4eeb164911289f08edf750e27a42add1eb6deb6f3c0979d7fd77e8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bda2ac6807ab2fdb55a1e8f3a317af4d0683013a29929ba79a6b3887a08e927a"
    sha256 cellar: :any_skip_relocation, monterey:       "eda5b527efdda403a4053c17049d43143a23f3f805adfda8816d9be4a56a7dd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f0a921e2c779a412c738de35b25dab5ed0698129d1f4a2e43862d1e8512ecc4"
    sha256 cellar: :any_skip_relocation, catalina:       "1a5bc699e0c007215328de54dc102bee07621e4706a554e0974b57f9f43a35ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d2bf9cbdc9d4772949876ee9dee8a2ebbd2de10f47d0becb43eb8f226791d9e"
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
