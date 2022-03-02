class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.0.3/fiber-3.0.3.tbz"
  sha256 "d504499a1658f0d99caefbffd7386f2e31d46ceca73167157fe4686c41e5732f"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed1e855c873517f0a89fa0ea4d622e75f102fd28af1cfc01d082296d34d07090"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17da08bdbb16df7335b0aa981d4931a7bfa871acc7e841b8b9ffda873c70d56a"
    sha256 cellar: :any_skip_relocation, monterey:       "ec871bd88ba1d5d5eaa1ec069bfa96f2f02c4de71600f9f56ff17c8fc6c0dce0"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a9d09c39a4fc1e56f751500759f686ac7c5100a710661d4f05fbc5424781eb6"
    sha256 cellar: :any_skip_relocation, catalina:       "fb6390c92e0d3825147b6e702dcd5b984bcb7894369fb7b564b2934b8a6a6926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71209f7799de0c551ebe1ad3db1bbcd68605f3cedbbdc01256a5f03a8c3e927d"
  end

  depends_on "ocaml" => [:build, :test]

  def install
    system "make", "release"
    system "make", "PREFIX=#{prefix}", "install"
    share.install prefix/"man"
    elisp.install Dir[share/"emacs/site-lisp/*"]
  end

  test do
    contents = "bar"
    target_fname = "foo.txt"
    (testpath/"dune").write("(rule (with-stdout-to #{target_fname} (echo #{contents})))")
    system bin/"dune", "build", "foo.txt", "--root", "."
    output = File.read(testpath/"_build/default/#{target_fname}")
    assert_match contents, output
  end
end
