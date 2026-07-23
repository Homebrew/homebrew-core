class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.55.2.tar.gz"
  sha256 "66291b68f34a8fbac53fda9a367a1fae31f620c6fd913c1004342b3c8aff0779"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "980788ee6ab3351993847112e9090313d772d92ae42770ba41b59b9b8cfe33e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "344b4efce16670a376d888b996baeaa640f6a6784b9abe2d5c7e582b3feabfa6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fef3b4a6fd0b0e4ee3b09993a1ec29b9edac918cea279c8341c96d34d88b29e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "77c1fe3361f9a69baa41db26dab6a8205b8cfad75af8bcc1cbe07223de57c891"
    sha256 cellar: :any,                 arm64_linux:   "9cb26e8a8628cbb1b2409e96512e53f74b0e6df4494af83ca6b61a2be8ef10dd"
    sha256 cellar: :any,                 x86_64_linux:  "5329d2a1a0d1711dd391438f889bcbda98651d8cbbbfbb4d57dfd3275dfee39f"
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
