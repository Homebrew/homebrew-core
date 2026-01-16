class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.51.1.tar.gz"
  sha256 "a7aa7dfeffc2f671febbfe8f642cbdfbc624b1de3ea818ed146c0e86cc716031"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d36bf6e9b744d4804c13f03d6180b9e7ff2c15b1bea971f20ae6c2df2fce3b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aaa2d4824af19277ee36d96ef31ac5b27945c5b976c78ee7c19b6f1854f585ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "641eb96df9d62caf8d7bd9a7a0c554aa4de39a62c491ac94dc2c8fb341d7c87f"
    sha256 cellar: :any_skip_relocation, sonoma:        "88092f3df210bc70c80515766293128738b772063e28a6c22450e5e93e10c285"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d81308441150f6f217a1e45320b35834f42920af02b02c7d6be817a2bb7ec18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5656d6b3d563c2483fe562766ae7e4f5a49d1dd8c294dbddbad5bd373fe5fc70"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz" # required for lzma support

  def install
    ENV.append_to_rustflags "-C link-arg=-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cargo", "install", *std_cargo_args(path: "crates/dprint")
    generate_completions_from_executable(bin/"dprint", "completions")
  end

  test do
    (testpath/"dprint.json").write <<~JSON
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
    JSON

    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"dprint", "fmt", testpath/"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath/"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}/dprint --version")
  end
end
