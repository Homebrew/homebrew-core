class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "http://cristal.inria.fr/~fpottier/menhir/menhir-20171013.tar.gz"
  sha256 "7c1bfed0bda443c40408c2bb2e2a4bae2f6168ac1d5a7e258117dcea83c51cbf"

  bottle do
    sha256 "b5f79dc5cbf10bdf50474cea7e3e9f5c605a6e15d886fa4f77512ee302a3f7b8" => :high_sierra
    sha256 "58a80d67fc3014c439ad1103b05acf31ecbccaaf20ed10360225071a4c6d215b" => :sierra
    sha256 "f180a3f9a9fd67eefc68104928fa7cbda1b2ed79cc9a9ee091fa511aeb02c576" => :el_capitan
  end

  depends_on "ocamlbuild" => :build
  depends_on "ocaml"

  def install
    system "make", "PREFIX=#{prefix}", "all"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"test.mly").write <<-EOS.undent
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
