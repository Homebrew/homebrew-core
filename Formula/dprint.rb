class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.33.0.tar.gz"
  sha256 "4629811063025528b9c51393686b6a7cbcefdbeba3e5c4653242a7518b58e69d"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ecdc9537ac862a5b5234b551db0ac5ea48ad6d0bd4b02b92a7bf3e8e7255988"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9243e743ba728b6c371430ae742bcded358f9bcbddb50b9e0350af31057314c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "907570acb7daab49c11df2f35e9f5a7db88b5fe281cb6c8ec16f104f0f7de423"
    sha256 cellar: :any_skip_relocation, monterey:       "b0f2a0a0bae9869ca46f7d6ac6b3bca8babb01de8098b53a7ed16ce3f26d206a"
    sha256 cellar: :any_skip_relocation, big_sur:        "148c5143a2b17b1de873a5f6b8949454cd59ea87fe080e821cbc62a03dc00bca"
    sha256 cellar: :any_skip_relocation, catalina:       "23be71da269b7b48c2653e0ade9f4514031826a773a5e1de59bbd5856cf8b709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3306e4765c02769d169eac7cb40106a53833b66652fad3893812d359cedbc48"
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
