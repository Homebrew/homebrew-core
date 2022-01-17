class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.20.0.tar.gz"
  sha256 "bb3cc57c0b9da7de1cd764baae9babb7bdd9ccaef1324cdc4a6679af9542a7ab"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbf8dbd1e32f8053e707135a90588272293f117b3d688a07ec23df34ceb1a0f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8aad55a3cc70da7a5e1985af06a14b330a04fc1f7702f1f45977f6fc38401d11"
    sha256 cellar: :any_skip_relocation, monterey:       "09f1febf6ce9be886dd641289d79e4930cb54624f95253f3459eeea21dfbc871"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4e7bd0794e8a7f81c93c667c88e6269af38414b8c436d891ed368fab1d8eb43"
    sha256 cellar: :any_skip_relocation, catalina:       "f3aa77ebdcdcc21281c32a1bf1c30334c55ec1235be54d59cf98c8d32410a784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "575f405fcb709ed07e70c74dd8fc9b261708fcb65ba01399162f6c676655bdb5"
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
