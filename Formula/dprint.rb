class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.15.1.tar.gz"
  sha256 "b3e3fceb33b4c8f44bd7f8328483627fbe010455230ffe1ccd3389ff519eb1b3"
  license "MIT"
  head "https://github.com/dprint/dprint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4534e25196c8b0efb94a636cc90872bc71c4c9c4536baa5e64c4642d75aa554f"
    sha256 cellar: :any_skip_relocation, big_sur:       "ed4dea1e3cb6584e4c24430809cd48f1dcd324b6ab7319241cbee2e47303e7ae"
    sha256 cellar: :any_skip_relocation, catalina:      "f390ae726a28f725c8c434a8dfc828162d14ffbbdbb76042c16c0b008f999df3"
    sha256 cellar: :any_skip_relocation, mojave:        "e9038b06ade233fb7da78bdd073bebac4aa9166e9651ff5c1c89c6c58fe8d48a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9066d28a5e238a6d011458a7c99ffb33d9134a67c1105c2f4ad41e3f1e47d9c7"
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
