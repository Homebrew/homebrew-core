class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.45.0.tar.gz"
  sha256 "77d27ccbd8d866a6277792cdcb25599c78b6f47704456cf8bfc55bd4104cee91"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "964ecba9b9c40ce90f28cddfd1ac9307205e9ac1b7de0ed9a7dde17e4b562afa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c2bf4edbb82ef6813de9a4515da790e067dbf7f9b0559ac8ccbfdf02883d3e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf17624633d0efcd681eca98bdaa1b1185c32c84a5b03046b5a449c7a9f9a443"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8c2af25aa1aeca150de2141a2167db4679989ce7bc78dbf079e200eebd9b855"
    sha256 cellar: :any_skip_relocation, ventura:        "584320c2c0e1861593165bf025a42021cfaa7480000acd8fb4cfe4cde480c241"
    sha256 cellar: :any_skip_relocation, monterey:       "6af1d27d4c7fc9b5517cf0d1c84431fe043b31ae785eb156b4260eb3ef06a00f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4605befb082c33633ade3827ba2659f7864e54ac7c633a30791c6b577f3f0e33"
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
