class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.43.1.tar.gz"
  sha256 "ba061c506159df83c52529c56444b09296f130d5543764f868aedf5ca4a1025c"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "49905f08e1f3877693edc21433a984ad9c66b132840b3ba1877053a6e89b3a82"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b338e10a4936ca1d5799750fc02a58fb258fd1b8d69cf47f5eafcd035e59d49d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b1233ad06c885a814a38f99d6f5c08d3b8a5757f3bbf24706db21e35546ddb9c"
    sha256 cellar: :any,                 arm64_linux:       "41f0a46588633879e631f3d96c555d55a6cd30175aca34ae4669cf6ed3e4673c"
    sha256 cellar: :any,                 x86_64_linux:      "3b92ec9ccff2438f149da272dbb12bcef82758ef11694b97be0397a8d35c618d"
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
