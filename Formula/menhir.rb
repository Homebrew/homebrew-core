class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20200624/menhir-20200624.tar.bz2"
  sha256 "2c436b29f2374566f5e63cb32033a47106c37b625ce45be8ade6857ee6ef0130"

  bottle do
    cellar :any
    sha256 "1d8fe51d871a8ceb81aa9fd8ab2f6afe52827fd1fb9f44920db00d44013c9612" => :catalina
    sha256 "143e14a2c00f6b0ca8749c86d3c90da34f1a86b82c777aa0ecd10fd8287a9146" => :mojave
    sha256 "47f172389fa83b5c27cb50dff49253566dfe992e058a32d656c91733c87ac947" => :high_sierra
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
