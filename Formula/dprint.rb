class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.33.0.tar.gz"
  sha256 "4629811063025528b9c51393686b6a7cbcefdbeba3e5c4653242a7518b58e69d"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "432aa585f08d8d4ec16d104e2cc968466ba9c7e4e6b29015f95f1384f047e206"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21aed29b26e02a2a40e45fb2a9069e09033d8278e4fc6b4039b322e2fea2a73d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74a87a8748037e641db47005155505c505342cb50534096413b28d69f87a82e5"
    sha256 cellar: :any_skip_relocation, monterey:       "d5f3ac1be6910ea6cac3627556baa53c687c8adbf3455b49754dc9f51a849fd1"
    sha256 cellar: :any_skip_relocation, big_sur:        "ade10e693488c847dabae16bf355b8e5c95f38cb803f7207fbd9bc5e6524bc41"
    sha256 cellar: :any_skip_relocation, catalina:       "1fa6e955adbf4b60902c78a3bca322f05db6dfe31f116719267245a7e2d72f24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8f5daf8c6484f4aba0224bd637d0640541ce75acf7939eafdd69b335fabc583"
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
