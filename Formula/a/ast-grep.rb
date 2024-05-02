class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.21.2.tar.gz"
  sha256 "f17f29ebd2930311b2937204b7ae812b956f41bdbde57830baea22f6c279d04c"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "561a92b4a17e054db67c201ff2fdcbc86b77499da215a3097cb8e394e7d93e9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87d7921c87af39752c7e6970a7c487097987e0e168da1f0a5b15d712fce05cbb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36f18198ddef1f80fc854c5e44e1e213e2cb722ca078c4de6a8a1336fb75417a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a830e752f6ab46b5299c9488404c537307f45e69db99f331dac90b343e700ba4"
    sha256 cellar: :any_skip_relocation, ventura:        "cb0b336ebbb2560d5720978410285d0270068ba5ce6b209e7bafff3feab77857"
    sha256 cellar: :any_skip_relocation, monterey:       "f19115d47814555d18730a70df03cffeb68b9cc99796a030aaf8d9a47cd7bbdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80ea423cc7d65d07af1e5415e768e88434f0ef08bd5d1c9e88b500f58febb9ae"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
