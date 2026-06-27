class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v2.102.0.tar.gz"
  sha256 "e00c3e04238699d40158bdb6720af604dee21cce06a2d3d21ed92d2234da84c4"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "279bb0ea0716d1e17532e327b6a2554bb2382cd0ab65e789d2e1e90aadcfdd6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c9263921530280c5f0d5507b4a772b589615780e71f78f95305819c292598c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de36df17598ccff9f64b50b1c1d574b20b3671e19c2fe74ea339f90f9ba4b409"
    sha256 cellar: :any_skip_relocation, sonoma:        "65bca002f741dcc8f17d8b0052e732c83015065589f56d625c1808185af224f0"
    sha256 cellar: :any,                 arm64_linux:   "1a5e47280233a0f74b1762a0fa226a6ec3ee9728c28ce49642e15a357709a87e"
    sha256 cellar: :any,                 x86_64_linux:  "9bdcba6e334d4b8aa361dc1e268261c1a6f1024cdb9c7db6c8a0e89b6ba8331b"
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
