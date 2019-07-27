class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20190626/menhir-20190626.tar.bz2"
  sha256 "27639743c1a7ba7cdeed3e8045bc28bf162475d2a99255aaf73da56c3e5fd28d"

  bottle do
    sha256 "7e434bb97950dd0019b43a01ecef5ce0737cb4247e070afb0157d8dffa68c8cf" => :mojave
    sha256 "cecaaa9bed5bb461e3342b591d9e3c86805fa0a4706abdbf6b09c57d7d83e4a0" => :high_sierra
    sha256 "26f11583b32317cf934fa8ae49ae93a467014f46feb705218ae7610dceb9567f" => :sierra
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
