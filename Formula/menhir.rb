class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "http://cristal.inria.fr/~fpottier/menhir/menhir-20170509.tar.gz"
  sha256 "36a690856f972adaadcff0138380b563f92041aab9d5dcaf29da1c27c8326baa"

  bottle do
    sha256 "941ac6971cc025ec64855fbc30b72dc23ec1af2095185a7653e5749dabc5ddd7" => :sierra
    sha256 "83ec68613aa79950aa71e5b36b41d31f226e058737726f5de8a71b8cda9519c6" => :el_capitan
    sha256 "acf20752b6ca88cf359ac7ec81606ca10d9c3c730862ac837af62ede0a08709b" => :yosemite
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
    assert File.exist? "test.ml"
    assert File.exist? "test.mli"
  end
end
