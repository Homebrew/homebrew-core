class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.13.1.tar.gz"
  sha256 "1de98e2e629f18e9ce1ee2d7858520b120b823e615ff4be1da60bb2f0c67e964"
  license "MIT"
  head "https://github.com/dprint/dprint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "04ba96af2bb01f286e5a5cde7c422e9388658ab29529ddf8d3dd3f261a6118cb"
    sha256 cellar: :any_skip_relocation, big_sur:       "33452d1c0253206eda85aa47daafb8ac8b704763492fe9413b73df49fd857f62"
    sha256 cellar: :any_skip_relocation, catalina:      "cc1b40574893b04ecee7f6f8147b0ceb7df96fe426c91eb894660fbb33b7bd73"
    sha256 cellar: :any_skip_relocation, mojave:        "9f81a1a3e5fa078e60e65e60201eded2298db1e01acdac278ae2cbbb3810d1d4"
  end

  depends_on "rust" => :build

  def install
    # replace `--path` arg with `./crates/dprint`
    args = std_cargo_args.map { |s| s == "." ? "./crates/dprint" : s }
    system "cargo", "install", *args
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
