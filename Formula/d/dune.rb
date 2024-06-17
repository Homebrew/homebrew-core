class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.15.3/dune-3.15.3.tbz"
  sha256 "3c27c7676414056f0368a71fdc670d2b0a59898090c78a1b68230984e5beb713"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7391e3e3cd176e662b2fdbecdec60d8ca914c44d211a1c228d828421f28e602c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9e4399a2e350dcb9bb5e08965ae7c6dd9002d37bc021cdf8370e3555df33bd9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d61f0908f04871a5796f59d3bbc5ca3f4f7707c6d5127b2976b67a17652ed741"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0b8d7677ca6d785365a688e3474a217dba01381bd738e93a49c97ce600cc3f9"
    sha256 cellar: :any_skip_relocation, ventura:        "d4d2f586943ba5034e3b59a4caa9c4c605fec32a71ae6db868c614d473a85b99"
    sha256 cellar: :any_skip_relocation, monterey:       "489b869f13712be7bb3d569ae6a2458beaf91216ba3561b7d518a56fbf366a04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a83d980c212d5575c71091b93e4b5ab704ab22512f9db2d6bd606a25186764bd"
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
