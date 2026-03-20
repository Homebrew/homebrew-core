class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.53.0.tar.gz"
  sha256 "612f987dcada5caea4335a03f986de245093622ce5c1e19b490b0e5fd13fb908"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bd37cdb2e063718399847e04f267ac1790e253d1005ab7f5bdcb1a5ab162594"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3591ab4ec1befbadfba20c3881697d661676982df6aa11ab7fb4b5d278c2b5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b75f03c93a820b84330bb2eee439f1d737a1327b4508ecccd9b71052d563e7c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ae40bc44a07655dcd8d6d2bbfce623963805c5608454fabc5fba91b004faea0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df905d333e0827e5d70c6ee62d187f0f17b965195a961b99886462f9396e7aab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7fc7d76985e620a7c802bd449941d08c452ce82c7f9b9a933bdfec2a881173f"
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
