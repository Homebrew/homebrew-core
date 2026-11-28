class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.50.0.tar.gz"
  sha256 "71d3165df9baf4de51a35bf4e1a8bf813fc271084d0fe2615e7dc6b9bbdd03c1"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    manifest_sha256 "e7d22bde3f25d8b8c806fd3e4c3c08afa9a57a0bd2131f74501b0f4da736d79b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4f8e38cd60d3f019d704811fe529792cd74d8e7dbd160212d17e2155f51b6c55"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c83e7ff759008689310a63ecbe2d21894a14515d0bfc427c53e925153db560c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d7615099d06742ccb698518b78e030274ea97cdca17e8be2b7cb88b748bdcbb"
    sha256 cellar: :any,                 arm64_linux:       "d097cfa4f5d1ab690b7e83b9d08d5e8c9cda492e58d5f639ca95f4595b257f4f"
    sha256 cellar: :any,                 x86_64_linux:      "fe4904b2139753271f4d755620d2563db0b0f6ff3144b1b78446569e822fd08c"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "tools/similar-code-sidecar/Cargo.toml"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    system "cargo", "install", *std_cargo_args(path: "tools/similar-code-sidecar")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "scripts": {
          "start": "node src/index.js"
        },
        "dependencies": {}
      }
    JSON

    (testpath/"node_modules").mkpath
    (testpath/"src").mkpath
    (testpath/"src/index.js").write <<~JS
      export const used = 1;
      console.log(used);
    JS
    (testpath/"src/unused.js").write <<~JS
      export const unused = 1;
    JS

    system "git", "init", "-q"

    output = JSON.parse(shell_output("#{bin}/fallow --format json --quiet --no-cache"))
    assert_equal 1, output.dig("check", "summary", "unused_files")
    assert_kind_of Hash, output.fetch("dupes")
    assert_kind_of Numeric, output.dig("health", "vital_signs", "dead_file_pct")
    assert_match version.to_s, shell_output("#{bin}/fallow --version")

    status = JSON.parse(shell_output("#{bin}/fallow similar-code status --format json"))
    assert_equal version.to_s, status.fetch("companion_version")
  end
end
