class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20200211/menhir-20200211.tar.bz2"
  sha256 "003df5e553660a8bdeb9a9f45185f8c5dfa63f85f361ad494dbfa81eed34acbd"

  bottle do
    sha256 "952a8ff899728e6659adac3365c21e790ad94528d63402310e80a30efc9fd479" => :catalina
    sha256 "88521e07ccd13706576d30402742a55a54e8dbfe7626b413538884253465203d" => :mojave
    sha256 "901394c2d4b87d9faadbda9474019cf2eaed6c4f8dcbe268f532fdcf1d01174e" => :high_sierra
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
