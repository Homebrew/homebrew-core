class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.57.4.tar.gz"
  sha256 "883cec00313e500f51a3a0b828144f5b2b2f8ad41b8baccbc8369b5c86550535"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2d4f0013857de3f17205565ac6a661ad0711ba57cf8fe24a5524463fe5b24570"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e4cf22b794659a2954ff52c0dc0fa076e864d3f928bffc3fc15a6ed5ce6c2393"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a103c02b762c2566aabcd44aa3db069a1e50dbdbfcfb5b1effc2007a145762bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "f4d35ccacb3b88c0486d848beeb02e2235f3ec5ae1c58f66d7ea3b949a321be7"
    sha256 cellar: :any,                 arm64_linux:       "f20869a7d0b3e861adf006b30ff02655b61fea41bf9a1f3921008b87dce6ba3d"
    sha256 cellar: :any,                 x86_64_linux:      "e382f7c4ad66d23d1f10c690dd6500f9c2f3f9c8ba5830ebbb29472cb0118110"
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
