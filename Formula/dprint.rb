class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.22.0.tar.gz"
  sha256 "eef5b93fea6097a0e07aeab3e7529ef3b5072ef16e8843c7ab87404a39fe7a23"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc998badb72c0058c488fe2e6ed670111724e536d8bd97f921b5c37f5eda51bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c3485f32680ea7dbb171f59ac5a4eb828f91c90b4f7b5a8e4268bfecc0de999"
    sha256 cellar: :any_skip_relocation, monterey:       "8a7af1f8ea0425ae28c663cbfb0aedae3a7cbafd2f5ab3de25307aec3d7e0373"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fb455eea2dc611746648c22bdc357774de4b3ab2f69d672f8b75a9a485fad90"
    sha256 cellar: :any_skip_relocation, catalina:       "f131e475f1442a2ded0a17ca932ee93cbc558a6ae7f96e732acbbf7baaed4720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa8776862448bba0bffbfab1c7b10a8a3f41970d01aea22b5d919f7b2e9bbf90"
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
