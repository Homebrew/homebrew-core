class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.40.2.tar.gz"
  sha256 "06afa0d071a35d759d8f5e480a52c3936c3daa85d1053df48a65fcbb1074683b"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "001ede99b97c826e6405bb23de5b5ef4cd66b16601909284f0ca17935e06c2bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9a9cb7197192e4cbaf3ef3a622b61c495fc3c59126da669747de8aba075c2f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a81a4916e255509c8a5d655d133fcacdd709f3f8f44920135493ee57d87dd4e"
    sha256 cellar: :any_skip_relocation, ventura:        "fb22f51c02fc1e73655c5406cf9c85f328916541031f0c4ef23ae7787ae692ae"
    sha256 cellar: :any_skip_relocation, monterey:       "77f3c9c325f54b8b20ed9648ef12bcf7c7e24d7d9fe2748292490eba96323d67"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f2d79a8542d6f940131c81e16853f276ea9c03b1addfd574cd42faa3707c5dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c754ce0142b9174d4b70926e69fd284ab3b5ab9c519c61d08241b7a3defa208"
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
