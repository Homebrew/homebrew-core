class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.35.3.tar.gz"
  sha256 "1283de8e2fbe3c24e2b235d67672ce0ae1f1ff245e0562fcef3723153d89a9c0"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84cf6424fb244170f98957b814350b66de519854a36973d72062a052c2a0c176"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88b746e9f38e8184542d1c2ec86cc28d29ffda971d6c581de9b520a79d0cf517"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91863dcfae453beab5f42380b5163ff26108b89e8f6e34cae6cccd2b09ffb2e1"
    sha256 cellar: :any_skip_relocation, ventura:        "aa9531cc4f42e17786083e7442b16b36bedc9d4fa41880cbfe93c9b6be5009f4"
    sha256 cellar: :any_skip_relocation, monterey:       "5d5803bc6424c6e8e17a2ef2f4b67be54d1ec447db16d1cf980a60426834dbda"
    sha256 cellar: :any_skip_relocation, big_sur:        "579d0e5eaf9e4c875812d9fbe118719ef9d2ada67a7e9c76a8748e31a3cd7cfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0418fb8890c8dd4cc8810ffb98bd7ad7b797263fc42883e4c4df7087677d6395"
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
