class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.47.4.tar.gz"
  sha256 "ec717f6a2e013ca902b7b25b4de49df33a8dda973c58973191b008e5c4edb207"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b54d1af52534bb3dd5b7de957ff465b4e228b65749b91822f8b03cc9b9883cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d83a2ac494c60b6fd45504a40d152aab998294e6f40dfc1727894596ccb10eaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58e35c96656238f8162fdb7127b3d1b897701ab17fad8c1481e4c3de8f047dea"
    sha256 cellar: :any_skip_relocation, sonoma:        "b341cd29c616ca9dafa3beded4fcb4de6c6f5380c8e005f1a594c0b494af35da"
    sha256 cellar: :any_skip_relocation, ventura:       "1c46135951ca03bf08939c6d078bb248a0079feaa3629473db69a6afd0965c26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c21cef66279690ad13299772c25d1f9b6fcb979afdf8a6cc89f39286502555cb"
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
