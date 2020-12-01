class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20201201/menhir-20201201.tar.bz2"
  sha256 "303309ed57f74fc491fd2b5069868ca871ce5dcaf602c4489e221bdcb89481b3"

  bottle do
    cellar :any
    sha256 "52b75403ba8020c4b2005c6bf57a335efd93e31f7f860fc9d0f421f46e222090" => :big_sur
    sha256 "603e059bbea3fa6b4e2c8b08ba28b51c613fbc2cd9678b35f0383839362e12c5" => :catalina
    sha256 "1bb5089c7b12ad0a8fbf344b491854f9e394ba097d825c6470b86bb0375d0250" => :mojave
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
