class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.7.0.tar.gz"
  sha256 "f8a27dca23850a0c57c7aa3e1005efaccc6d42b427d4e39a9f80e93f72cca72b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3334563aa0bdcc18b3a3bc4f4b8c744ff5376340d05cf7029cc2cbad1fd8f0c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fa4efb5ad31006ddd5a4050b63a5bf5e779c08bebdb83c7efa2020c33d6ab09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b1a43659d64afd88d504b0aad3ce223e392f9014e1248c73454a0f09feda2be"
    sha256 cellar: :any_skip_relocation, ventura:        "2ccf01c9eed293ac7f51b0faadecfbbd95c25b397e87602f97f8b8f87965c659"
    sha256 cellar: :any_skip_relocation, monterey:       "1ece1194feb22dfa907a784de7bdb633c7c8f96415f9835b5a1462982a2fc78f"
    sha256 cellar: :any_skip_relocation, big_sur:        "dad1a62960f670849418d8f3fd8aa40585dd6dfc4501220d95b2486aa89bb5ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9333c88fd1e98cba04b833df880775bf72e04140f1ebdd3d6bd932723b86607"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system "#{bin}/sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")
  end
end
