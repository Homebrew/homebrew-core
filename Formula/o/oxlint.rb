class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.63.0.tar.gz"
  sha256 "ac6d35c497ef86c258f324f6fd5acf2dbf81eadcd8659259634c972a16f37db6"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23dddc00efb1b1e922899c3134d4e67cbeba06fa07438a40223011d31d66f1ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2381fdd7185d7dc6e76c3a9dc7b0736fd15323253862e6186b3589a0e855226"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f980a065eebb21b2ebe044796cad0aa62d9a12b68e82bb08f975fa636debca5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7873f52124dd95a401c7f3b88df5686ab1e53ddb5a715161869102cad94ba237"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ba02585e8e9bfee2ed805c377f0a9bc68f649126d72d2d1e83bddecbcc1d197"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b39fe845e851cea94757d1603b8e9331488a0a4a75f9411b6bdad62703142bfc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars)::Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end
