class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.55.1.tar.gz"
  sha256 "ea59bc3c688182b32ba8f4f6f17a720da460f70c9f8ba57fb9735334c749c463"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01dbb46ebc9a23a5a29b1bb7c774eaaa2ab734c4a8c88f9313985228d1d837b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f2e82988950a368b3ef31cbfa89cadb61eabcac9072c1261c47636fab578ec5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73e683c5c2a4a589a75e8a45ca14be3e9de97aa7892fedefef8024acbb6f3039"
    sha256 cellar: :any_skip_relocation, sonoma:        "186ad8966efff9e1ab5930a20f4baed690edf2de6f492d771aef8cc39f272518"
    sha256 cellar: :any,                 arm64_linux:   "d2a5c930e048d826c0abd962068725caf919890a758edc7c727531f98be4b9de"
    sha256 cellar: :any,                 x86_64_linux:  "92bf819ef38133dcc57d1d0c7a22e5b2cd353a7c6ac69e661b657a5d22d79153"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz" # required for lzma support

  def install
    ENV.append_to_rustflags "-C link-arg=-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cargo", "install", *std_cargo_args(path: "crates/dprint")
    generate_completions_from_executable(bin/"dprint", "completions")
  end

  test do
    (testpath/"dprint.json").write <<~JSON
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
    JSON

    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"dprint", "fmt", testpath/"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath/"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}/dprint --version")
  end
end
