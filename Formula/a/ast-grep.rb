class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.32.2.tar.gz"
  sha256 "ed36c448bdcb538497d17dfd4e1a8826c096662dec020ac99a77f4945793a9ea"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e8de5325d97d2daa072ac79c0271e443dc6839f64f3f36106b6499a4131b7d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7996714a5297730188fdbb2ffb57f4dbed4268e05797317285f00ac27b7bc16c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ebaf6c4f62c5ef7bb1a84183cfedd66bb166012620c159a1e7b84d0250fa5c15"
    sha256 cellar: :any_skip_relocation, sonoma:        "9034285a012bf1635dd1af0c499d532b814a7ed7440f5186b922212e8d623328"
    sha256 cellar: :any_skip_relocation, ventura:       "5588b8345334ffcc5ef8b7d2db199c9803a0af51f301043a89199b464824ce98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84c58a9b20636e1b0f27fc4ce8b037737a6846abffe7a4a95446c45a153f6308"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
    generate_completions_from_executable(bin/"sg", "completions")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
