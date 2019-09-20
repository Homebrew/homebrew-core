class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20190626/menhir-20190626.tar.bz2"
  sha256 "27639743c1a7ba7cdeed3e8045bc28bf162475d2a99255aaf73da56c3e5fd28d"
  revision 1

  bottle do
    sha256 "d0ba1b0ca38d85177a02dc457c8e873cd4d1909dbc4b198161c80ba97765a1e8" => :mojave
    sha256 "b23ef01c671a973ff8ad1f2f9e1563f0ec2b348edda1d7f3ba716c343ca687b7" => :high_sierra
    sha256 "bbd7c51fbb7f3167328bfc0e7c7a6f28582509b32c7afd067e4acb7115f74112" => :sierra
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
