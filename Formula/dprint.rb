class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.27.1.tar.gz"
  sha256 "2a8aa1111149d825ced8809ff41852c9ef5e43ba5e000557fdb40f5ee73df2eb"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aeb2ba4e370b5724219f0f4443bbfb919847e63d3aa5039958272c75b2d474b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7ed0bd602e35bade517b9e7f58c22e622ce0302f4e179bce0e5194a13d9e24d"
    sha256 cellar: :any_skip_relocation, monterey:       "7f34abfa7ef79ff6673916aa4eaff9d95b8a55668b9f0f8a9b76af99b5f2b80b"
    sha256 cellar: :any_skip_relocation, big_sur:        "952d8926a1c7e651f212031daf9c3818876b7632bdb4487f2e5eecbf647585d8"
    sha256 cellar: :any_skip_relocation, catalina:       "9e0d26e21ca0c570afbbfe6ccb17fb9032bb2c6c736849961ea37b45e59ee120"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30194acb12156d1127e7e2899ecca7fba4b732866ea4bf59be01322a7c6ed9cb"
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
