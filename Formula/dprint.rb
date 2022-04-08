class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.24.4.tar.gz"
  sha256 "877e32d2b07df2389f976a02f390dbc8e562375b24802c31d49109287bc111b1"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bab139960dc6e04ff4796adc57c32cc9f3089f299503794bb5c8d3b5286b2a8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99792833530c0699b39f9137e28ac25e3df437da7302a025105fd4dac8a09b81"
    sha256 cellar: :any_skip_relocation, monterey:       "1dbaae38665e3673e2da976526b250f07f5e60d3528d038b8b6218f8fa420fc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "0efa2c8d08e8a588f4cb81470f6bf1f00c9d49127af33d925f1a3c84d50d99f0"
    sha256 cellar: :any_skip_relocation, catalina:       "5f83f1c219e53d623d104d7c20493f16f219d1219edb2d57db5ce6842514a5a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36b8d6f3bfa1d8abb03ebe65b3f35d64c220324ade319dfcf0812351252e962b"
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
