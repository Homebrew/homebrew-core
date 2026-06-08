class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v2.89.0.tar.gz"
  sha256 "316c5145dac35c5e4f8cac1adc399aa2a5c17b58c639ead6caa11bdadd272aee"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8ecab58049bb98b6c0364948f6e10ce7faf27561adaff7a75055eaf2b5068f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6add4436fcaf0a84eac13c09789e6fd4a5f0f7b81a965aaf2686b514749715ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71dc5edeb10d06a3d5bb88e8dde5f92f902c5a74e0fbd167575ffcdaa96f7b89"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0ef2537a4b39c731253d081d70dc538de5d30320e576b839f8edca782d53350"
    sha256 cellar: :any,                 arm64_linux:   "2c4643339075146b590170b414b7c20ff471d3c6173b79a4dedbd4db0e4d7543"
    sha256 cellar: :any,                 x86_64_linux:  "b345b04aee5492196e073025f11003e3416069b22a0eeea15c68cdfba2014460"
  end

  depends_on "rust" => :build

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
