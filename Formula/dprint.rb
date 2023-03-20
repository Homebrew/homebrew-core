class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.35.3.tar.gz"
  sha256 "1283de8e2fbe3c24e2b235d67672ce0ae1f1ff245e0562fcef3723153d89a9c0"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f815afecfbde01e172542de4411bac4415906fd88f002bef79737011afab5b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8ad2e51b135553469aa517fadd8373c993065a41a79f6818a55bce1d4a803b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac29427ad1b48678cf5f142448986e7efa4fabeea454549f5ff36d53bf7f43e6"
    sha256 cellar: :any_skip_relocation, ventura:        "3fabe6c02e72bdbc882d8dc4c3b0efa1f582e1c992a6ac7ad83db5ef9c388223"
    sha256 cellar: :any_skip_relocation, monterey:       "5b88bc73062fff9e76e7148cc28bf5a2e1be49d913b750cb0504426edfa3f9ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "a88e24d16b177c730ed6ee0346a493a7953c972d682344810010a1b8bbb9d36f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fcba7319f52ac3aca2a241ebd9ea13f5d90cd8eb556422f4bd3aeb298de5e12"
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
