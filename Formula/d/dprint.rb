class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.56.1.tar.gz"
  sha256 "f5c102e5dbabae9cf92d8ca519dc4eaaa5f1fd7c66ad74bb791ab0c5d341ccc9"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13c368be948b24b2c51c1a746d08f87678b9fedfbba4c3630236fb75f4a77e18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "991c8b71b71cf1b4f5e0053faf55d45832eeb5dcbad0247c294a13996b9dd767"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "380f0c4c2e32c7f7224bc6260ad2d257f954e487964172172250c320bcd4bfcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "890830850cd55b95af6114d05b254d5f3a700c9ec32d6a35702aed0ae16708a0"
    sha256 cellar: :any,                 arm64_linux:   "552d200bec31eb1581c5c590a2dd1f0310535631826ec54a59bacae628e0c0c3"
    sha256 cellar: :any,                 x86_64_linux:  "6c94536b2e9df93aa8bbdc003fe7d36fbd282b5b46bce79f6ff0907bcde9e82d"
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
