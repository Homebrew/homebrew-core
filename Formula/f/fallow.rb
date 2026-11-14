class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.43.1.tar.gz"
  sha256 "ba061c506159df83c52529c56444b09296f130d5543764f868aedf5ca4a1025c"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a0d18776f129fa3c21881419d41e1ef52c10478b9adc2a85b39759e925525b03"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fe52bf7bf8a454944905406d46c36babc369d18030d83c5b39f7ff4741e6adb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0b1652c83685c2380c336bd53f3a4e708311c26c4c6e953189ba4f45810e709d"
    sha256 cellar: :any,                 arm64_linux:       "72e940896226ff257daa95b27e68036b414e7911bafef294f117f1ee5968c10c"
    sha256 cellar: :any,                 x86_64_linux:      "b34723c7a90d171b55d0039dad0c4a73941a239f791fef28012bd77b4d3ceaaf"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
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
  end
end
