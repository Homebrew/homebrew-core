class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.50.1.tar.gz"
  sha256 "85197a9469fe479fc278e77e87ede6eeb55b7d42d0a530e8b828f3ab9b213358"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94f0c63c279e6557b34abaa5a3daf13ea74a4cc8ad12589eab0b3093f27b7fb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c743935d64069338d522f7b6d6a75f6b46f9e2cd9f8abb8dafc6f404a66ac51"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e37f2baf1a456129bbf18c038aa5955ea13b936fc53464c953d42c0296fd290"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f4c59f4c7cbc9f3f96b7d6673cef9cfa954b19762b6ad4e804cf70ab114f17f"
    sha256 cellar: :any_skip_relocation, ventura:       "d6f12a4a3dbfc3f65320207500aae56e03c7365206ce800b45d2b643ea8069bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5f24e032a52f6ddfb0ce867d0c16f702b31eac5cc22a607c1fdae53999d8698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97407733307f31f970755ee15f12ca334e32287e5d0350d900fab3e6276de496"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz" # required for lzma support

  # update deps, upstream pr ref, https://github.com/dprint/dprint/pull/1003
  patch do
    url "https://github.com/dprint/dprint/commit/bb6ddc6034f73adb188fb2c40aa34d0c6a7ec6de.patch?full_index=1"
    sha256 "ea54bc0c12dbd3057a0c95d4c922fd35459f338112c14eb8dc4fe96eb742a733"
  end

  def install
    ENV.append "RUSTFLAGS", "-C link-arg=-Wl,-undefined,dynamic_lookup" if OS.mac?

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
