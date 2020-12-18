class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20201216/menhir-20201216.tar.bz2"
  sha256 "bb9f2755e66b2a2bd60dc5eae979b9f56a119d45c892a1c6145f998b7467b59e"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any
    sha256 "d2cefb1d8e8679596b02fae4d5f98a28a9cd4111a4f174f63f87d4743a8edcd1" => :big_sur
    sha256 "80333d2849f55edf37e94472f6f9c659cafc098d9ed12afee57928ef7d7f0b62" => :catalina
    sha256 "0d20cbd57d8a54711240e0770e6c2790463f0825d7f16fd1cf3d78f5b43eeff3" => :mojave
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
