class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.65.0.tar.gz"
  sha256 "e38e5725b171e6b80e213e278e8e929c672a466f83ea20c68829ab4fdd0b8380"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    manifest_sha256 "97cad55c725ecdb22c7a1155f36fe07c6d497e4a224a4d1824a5b8d9805d79af"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "37980da6a5b349faae92a40dca82cd045a02cbdc81e3f89b18c2dbbe0186e3a1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2d8addea5d0aa6a0c650ce5c4107f99068fb5a76a5f09e17ce9fc79b9f845882"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "99070c69e77b336e00651f05a72e8588d38dd4971e7cab473792ff435b938adb"
    sha256 cellar: :any,                 arm64_linux:       "6970c170b870a1f6c44f23b2efb160a5ae37eb95cb394d197735b6f91cbaf731"
    sha256 cellar: :any,                 x86_64_linux:      "e3d7b5de23d0cc6f61042780869c6b1975b813fcc04c4daecd180ab4eaeb2ff5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz" # required for lzma support

  # Test downloads dprint formatter plugins
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
