class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.50.0.tar.gz"
  sha256 "28a9538c293a1cbe2af8241d687c44309dd1aa1c514c6a937ef3c25699dce4ea"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7893a7360baa4540a8f29c450d0670449db12cd9d857e7ca9854631668ad30d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "703e06bef2c9c9d0fb74d03bd00a303398d4001080653101a8bd4f72547c7d31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a59299e27deee4819d4d47cecdbf93cc9d0412d6ff34ce645260fc232ff1a439"
    sha256 cellar: :any_skip_relocation, sonoma:        "99b08795bea3987a248af08fadd243fff4f35eea291069c15224b0e34b876f32"
    sha256 cellar: :any_skip_relocation, ventura:       "ffe2efb94cdaff94ee5833ea56cea07eee8821227d92e6df7f4a131b2d64ae87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e215fd8b93370de515391208e0294bc6da83308d9b08f7631fb1df8e61319ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80f9512b0ba9365009f00e66fd0dacd276afa2a8ffbd265a050b8e7098d2aa83"
  end

  depends_on "rust" => :build

  def install
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
