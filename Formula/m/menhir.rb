class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20260209/menhir-20260209.tar.bz2"
  sha256 "06f6e571aadd7d66cc3da808052d9a65f8be96fe27e0ad7e57bbbf8c20f4a832"
  license "GPL-3.0-or-later"
  revision 3
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "546e1cd4ba8a7893da26fec78ce33d2eaefad4b3118b5fc841d544e61d8ade54"
    sha256 cellar: :any, arm64_tahoe:       "78e2e65727781c9c4e63ab1b3d31810f6439dcdd8027e9eb75827ca7f5a7629a"
    sha256 cellar: :any, arm64_sequoia:     "6ff99714f26c7c8dfa9202d955855b7498435c9c7695ddc944ec399bf6796ef8"
    sha256 cellar: :any, arm64_linux:       "da010085a0f23f548ba035d9d764eb52e645baced3eca9b25f53e6bd9034f5e0"
    sha256 cellar: :any, x86_64_linux:      "2df00f7cee4cb6d2b3357c8a679292485de187925865429247daa53ded6c4a53"
  end

  depends_on "dune" => :build
  depends_on "ocamlbuild" => :build
  depends_on "ocaml"

  def install
    # Use the release profile like opam so `menhirLib` matches copies bundled by other formulae
    system "dune", "build", "--release", "@install"
    system "dune", "install", "--prefix=#{prefix}", "--mandir=#{man}"
  end

  test do
    (testpath/"test.mly").write <<~EOS
      %token PLUS TIMES EOF
      %left PLUS
      %left TIMES
      %token<int> INT
      %start<int> prog
      %%

      prog: x=exp EOF { x }

      exp: x = INT { x }
      |    lhs = exp; op = op; rhs = exp  { op lhs rhs }

      %inline op: PLUS { fun x y -> x + y }
                | TIMES { fun x y -> x * y }
    EOS

    system bin/"menhir", "--dump", "--explain", "--infer", "test.mly"
    assert_path_exists testpath/"test.ml"
    assert_path_exists testpath/"test.mli"
  end
end
