class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.17.0.tar.gz"
  sha256 "d3109c4ef77ecd8f8ae53298bc67d0656d6c67ff58858a39a207f0fab3221c34"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abe12df7fd05a3cc020d8d05d68acf8c2f8f5a6bb85b65b5102be905cd38bf6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86e0d0d5feff849c6133502fd95f79f6e6841d8d8ca474c49a4b29ae7b545475"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdcbc816ddd24472183c338f73e87a5b806ab3431be9e54696aa665fe3fbcd5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "811f5796816982a94d3c299a5099e09fb8c03215976995b2083375c36d98e98c"
    sha256 cellar: :any,                 arm64_linux:   "f2358e486eb828270cdb1cf6cc3390cdf126ae9d00e41e2d100594271dde6abd"
    sha256 cellar: :any,                 x86_64_linux:  "00e1fc13cdaf4c3db1ba97ec3ba906225436ddb43d1744aadb3cdd9acabd6bdd"
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
