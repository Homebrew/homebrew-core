class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "http://cristal.inria.fr/~fpottier/menhir/menhir-20171206.tar.gz"
  sha256 "c4ed86f2d02d72183e3422ff1700276925fe6cfa2f22900f3d30f23dce8e9c77"

  bottle do
    sha256 "794ef172ad25164af30f4f695cd8bec8afc0fe983609133cd38c94f700a732d8" => :high_sierra
    sha256 "9b130cd649e26901ddc8797564855e6e4b5b609f1c98626dcdb062a3175a872d" => :sierra
    sha256 "ded6e18c5b64a18f8c595e77e9d1162135409c66afcc5e0c9d6a37ca0f15ce48" => :el_capitan
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
