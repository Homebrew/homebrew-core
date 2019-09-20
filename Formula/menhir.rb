class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20190626/menhir-20190626.tar.bz2"
  sha256 "27639743c1a7ba7cdeed3e8045bc28bf162475d2a99255aaf73da56c3e5fd28d"
  revision 1

  bottle do
    sha256 "143bf23dead44014da531f0a5a80f79053d38ab9edba73dbf7f7c2daa2657174" => :mojave
    sha256 "53642937c209fa6216c1bfd72223eb408fcb04bf26a8ac8527ab6c2488373501" => :high_sierra
    sha256 "e4f4b8fc1a3e7f6b2a38834cf5707add48e1687786ab2eb017d95b67911a037d" => :sierra
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
