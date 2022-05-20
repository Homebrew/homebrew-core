class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.28.0.tar.gz"
  sha256 "a48a0db1f0a71f57ef88d7b4c8e93fee2ab88d53d7207ebc460c016a048c64d5"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97e0362416dae04b1fceba65e24fbf8bf1445b1b3f153e0e5f3f51e4d026994b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d77a2ad51863581a1cc617e3f2df88e587092a312b7f7208e2205c619721d282"
    sha256 cellar: :any_skip_relocation, monterey:       "847ae262ad1e01c55f38357cc7c05ab7c8a6ae77a5fe75f74a194b7cbe61a2e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "66560cba8cb1ddc91bcddd8407e723e32ec029eb2afbfe86828be4a5645b42e5"
    sha256 cellar: :any_skip_relocation, catalina:       "da895dd58036ced38ba663fecf98d947ca8ad07da51bfe56214eadd76aa1098b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "750f81e7acf6668ddb85ce899e42399372ac3da3af7f736aab1a283ff6459d3a"
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
