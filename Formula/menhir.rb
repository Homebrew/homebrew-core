class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20190924/menhir-20190924.tar.bz2"
  sha256 "0f1e5a804f7fbb526007fdaea643634b2987d0857e9518687d46cc1b3fa0ccc3"
  revision 1

  bottle do
    sha256 "e963a83bf180d78309541b212acfc4b75d56e7355cadad22abe4fb489588ff0f" => :catalina
    sha256 "38931160f68b4320651fdaa24087d940863152d50b8584e0d53c75839e824f2e" => :mojave
    sha256 "89e25bb684a2d14805005c836d4f0ec88d90ecf2a96430b14ae97ecd5f61de99" => :high_sierra
  end

  depends_on "ocamlbuild" => :build
  depends_on "ocaml"

  def install
    system "make", "PREFIX=#{prefix}", "all"
    system "make", "PREFIX=#{prefix}", "install"
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
