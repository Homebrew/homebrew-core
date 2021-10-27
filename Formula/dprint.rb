class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.18.1.tar.gz"
  sha256 "fa82158972ce9961c97ea0b06d8550606bce4174c3a304581f08f50c78101bcb"
  license "MIT"
  head "https://github.com/dprint/dprint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76ad8e0b6d5974264d84d929c2bf4aaa61585c84f21ef3b2798831d779ce1947"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a8aea65b37d424a35842688be35a1203ff8fb237c0baefd7967c3f4e322e310"
    sha256 cellar: :any_skip_relocation, monterey:       "a4768ce919ed0d2f88f37080579189db8948bbf9f4d0561596405d4705e5c848"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6400b334b244ea481a552cdc56b9590c9f7838e80a296d5a3af8a6036d69595"
    sha256 cellar: :any_skip_relocation, catalina:       "cb1411456754a8d0d39f5bc39151427dc85dfab027f5a06047d7881d05db3758"
    sha256 cellar: :any_skip_relocation, mojave:         "66763d9090aafe122099e27bd8908b6433ed700743dc301afc506575eb2e22b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2379ebeb45e67f110b429eeb729510c8835af120603776f6b0d2dc579f31d5d8"
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
