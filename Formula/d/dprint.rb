class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.64.1.tar.gz"
  sha256 "e2dda3237eb4e93832a5a88c2c76090f68fd1ded40f4bd701af8a781ac7ac1e2"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "47a96454d313025fd3146d7b7974e9f1a2ffbce5c49dfb8a4b03806cd5a275da"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cd485ed3da26522fb048f9a931865d1fc875a26339ed12d1f5b3fe697f294180"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a8fb036ef1591a8d6471619618ca5b924d35f1a26aa5992df0d5c0b947f4bc07"
    sha256 cellar: :any,                 arm64_linux:       "88e2155db0b17bfd9c931ca55538406d44f84fc84e328df1e715411b016c4e01"
    sha256 cellar: :any,                 x86_64_linux:      "5b6984c32ed71096b74a979d3609499efa7d7b18f0ddd6bee741ca446f5f2e38"
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
