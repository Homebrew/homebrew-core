class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.46.0.tar.gz"
  sha256 "f3db40eda9f415c9e3c9461bd08f00cb6de0f22c46e544da51af35f5e6a220b8"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1f4fc398ceaf4b1717d13f4bcd0c1dcc2cbba794a4b0dd0ce16f6eb6fe05403e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "186f828cc25e36c8baf9cc86440f8184827b17951828ad9235faa26249659294"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "10012f6984d302c43e09d63c071816aecbafe69a8c40c05c1ff9247c4c4e1dd5"
    sha256 cellar: :any,                 arm64_linux:       "ce8ad276d85b38fe87668fe1bb6c43c92c1b73d564c13dabe471a1a7d1d4a05f"
    sha256 cellar: :any,                 x86_64_linux:      "0d663220b2a350f61365e9a0192b473b71fda30f7b93b7f54ad1442c13eb854c"
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
