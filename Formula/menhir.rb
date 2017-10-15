class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "http://cristal.inria.fr/~fpottier/menhir/menhir-20171013.tar.gz"
  sha256 "7c1bfed0bda443c40408c2bb2e2a4bae2f6168ac1d5a7e258117dcea83c51cbf"

  bottle do
    sha256 "593281dfdb0a92ac867835839697e4d69545044aeb2cddd37b2aa748cfd898a6" => :high_sierra
    sha256 "57489d76a5f717fda9b2d78f6c049ad924f823f8536b11eb3e3aee2449207a3d" => :sierra
    sha256 "9d17da07dfecdbfc7bc3d26c74d1c92f6d5a0e546e6e9a2e4db1288ce5cdcbbc" => :el_capitan
    sha256 "fab74e052f76b06d9511e3cd3d68caed29027f0994016791441b009e09f7798c" => :yosemite
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
