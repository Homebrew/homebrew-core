class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20201216/menhir-20201216.tar.bz2"
  sha256 "bb9f2755e66b2a2bd60dc5eae979b9f56a119d45c892a1c6145f998b7467b59e"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any
    sha256 "2489afadf591e3052f81fc9219911e4c6d466d4933ea2a9fd44032f571e1abe4" => :big_sur
    sha256 "b5a6e90d021aa79d5b1b3f270bc4773b9fb06070c14ca1145b8ea04996ff7e8f" => :catalina
    sha256 "4d932e5fd011872bdc738b62ea7972a3ca6352aa5b7f74b59c3a5a3f9d4bea3e" => :mojave
  end

  depends_on "dune" => :build
  depends_on "ocamlbuild" => :build
  depends_on "ocaml"

  def install
    system "dune", "build", "@install"
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

    system "#{bin}/menhir", "--dump", "--explain", "--infer", "test.mly"
    assert_predicate testpath/"test.ml", :exist?
    assert_predicate testpath/"test.mli", :exist?
  end
end
