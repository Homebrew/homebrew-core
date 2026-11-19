class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.44.0.tar.gz"
  sha256 "75512f1665601b7471b5843313b87261305000329067eb7976392ffd66e71260"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "66660323cf0aef050928351ae2bb495198a9fc621c424a7ea48340fa7106004b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aa7455fd5f65d4e42bfdc4662fa55306a31c48eb468c43f2ff057ccf0bcb9fa4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5b19ff53b85187cb5dbcb76496f10ee7d02e67d557b5abba5cff3d109947fc02"
    sha256 cellar: :any,                 arm64_linux:       "667f3d5396baabf708b941b40594787e67720d4abfc480120637954ef350422d"
    sha256 cellar: :any,                 x86_64_linux:      "f06cf2201a69d48915bd12f9935e8d7d1615ef1d2d32d698af0ef7b6da891cec"
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
