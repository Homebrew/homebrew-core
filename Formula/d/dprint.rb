class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.54.0.tar.gz"
  sha256 "5a2748d4d0ba053727f78d5ef121c192c73832bf9b2303474eca8d6e9bc7635d"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ce446bf4d666d34116cdd34c38a14ac25cafc0bcc15d062bea39a42883417af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ccf4f5eef723fb6d7cf578dd25048a63674608d8581c0c68a5a0afcb7d6c68b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebbf3923aa6b61a02d60af8dc4ae4355e3be062f86cf4a7bfcf8ca662bca3c0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d35a8feb0a83ded26184e6a24aec240e5e1827e1f4c21f30211e970e45929134"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8baa8d6d33843804dc1bf874626b90d8f5449368744123d425d1305f0fa0521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb1f11229517adc4d059f391f731edf0ad0967d548978b8d160ba8cdaa7b413b"
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
