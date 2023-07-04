class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.38.3.tar.gz"
  sha256 "db101d9245c03d6ffec0a297b43646e9dfe74d19770e8bdccc0d530b9401b5ba"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0eb1ba9ca0b3376114abfc1518c8fcadc55a46d06a60113145eec7aba101b699"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c619e981a18e522537ce850d3c37b0478717c1a0512b595720859b0418bc2cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4d562c3cefc13f35bc322947bce8fb68fe00efc6cebb410ce8554ca3421d968"
    sha256 cellar: :any_skip_relocation, ventura:        "3d8128134f334231c5ddba6cccba00d493424d62b2fa312f5e11a84e36e2698a"
    sha256 cellar: :any_skip_relocation, monterey:       "e3fbda45cbf177a2e1040e90e3e582a91a1d643cb05d81560001f703882bd8ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "f67afe63f79963e94701e0057091dbb76c108ec870ec1cbd9cf3c7740859086a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40c9989996bbf2acbbfadb8319c7a78fca572e52365ba726c0506d5f55a92e11"
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
