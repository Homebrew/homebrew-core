class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.8.1.tar.gz"
  sha256 "acd03c1518740bd97de76c3282397e9e607beff28665c3adf55ec429c9370ac2"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "998125a064aea27580943d8c885bcf957b1b8aeabc8d0ba015b0361acfe09203"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a9d47ac221b01cdba9ae846161a523fbac88d3954366858fa2e46a8455b14df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fea1ef8257f39ceda56d86dc7094adadfde175926c569a06daf9834c1d7f75da"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4b181cca5176ee4bc2726526caa363cb26b54eb7c2946e38e6dd5e77a85749d"
    sha256 cellar: :any,                 arm64_linux:   "709f00861ecbf91cc9dbf969e1a429a85dd525b91b90a21be008febf6fed736e"
    sha256 cellar: :any,                 x86_64_linux:  "84209e5269d7c23ff6b88490c0d90c28f88c551f639555d8114bf9c96313eb19"
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
