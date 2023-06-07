class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.6.2.tar.gz"
  sha256 "9a87cd73e88c9664e8eec87730e77ca05c3a16753e6ba462c69677129aa39199"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae67b3cbcb47ab05499ad1239742ba01582aa678cea7243ae41bc43debcbdaf6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70d9ea96d18571dba4348f11dbfd381ed2b69f88ba9050c82a1f022b44c89507"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "806305508ab5f6faaf76a3b7b0e832fe0f0a8da7e0d0b4ce5be96ca681a32843"
    sha256 cellar: :any_skip_relocation, ventura:        "6940196e1e44c357b2bdffff398767b14e5646230ee17a08c37d4e7dc7171fc1"
    sha256 cellar: :any_skip_relocation, monterey:       "9a438ee83e0f8cd4408653d868672e4c2af5f4575b86cb86cd2d68e08a60f7a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "940f509ece83976bcecaf2c8cde67d89115d30a4b66f0793b3f38f8238d131fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75a145661b350e054351912eb6a35c7b22acb9e3a193d3d8597a8c59316fe179"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"Hello.js").write("console.log('123')")
    system "#{bin}/sg", "run", "-p console.log", (testpath/"Hello.js")
  end
end
