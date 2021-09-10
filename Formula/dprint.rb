class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.17.0.tar.gz"
  sha256 "0b101fb8ca3d1a22fdb588fd7f7f5b02409b74e70289267634d7ad220d95523a"
  license "MIT"
  head "https://github.com/dprint/dprint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "49f8293f48d6c96ebce6b34b71714671622955a62e3a8e6ba514dc0c10aaa6db"
    sha256 cellar: :any_skip_relocation, big_sur:       "ae0ea7461f87c69ed5370083314a74184f70d7288eb51e59037c098e4800cd7c"
    sha256 cellar: :any_skip_relocation, catalina:      "3da1b01cd45dd01c1f1d0947acd9fdcfbbcf63eca57271a9590315cd8fc49b80"
    sha256 cellar: :any_skip_relocation, mojave:        "0b2660f57e731c83beb185a42f4906d2e09952088a734153427db2b47efece84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5320db75655adf2b79ec58b3893193820c77c81b5295fdd2a4678408b0b5440"
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
