class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.2.0/chrome-trace-3.2.0.tbz"
  sha256 "bd1fbce6ae79ed1eb26fa89bb2e2e23978afceb3f53f5578cf1bdab08a1ad5bc"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e893ba9599a68b8b1e080849f1f96955ab6820a53f60bfe4fdf1713a098b6a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e5d5eef3c24376019f907793a422a9e95b9647440bfab286405aa8e48ad3e4f"
    sha256 cellar: :any_skip_relocation, monterey:       "37cf75fc9a8302974aa0322d8a5e07130be629f2aa20b9dc376c8c0fa79465eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "39dbc498ef4d5d7cd1858a0a13b3e97561d468cabbda39f6a6a520ebd85f3ebd"
    sha256 cellar: :any_skip_relocation, catalina:       "4a577eaf6533fed3744747f530644879e5b039967698597ad24266d1f3834f51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cd81f6d26d3083dc2fde2a97dfe2e089548e09de2b5b5b1f06c874889b98ff9"
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
