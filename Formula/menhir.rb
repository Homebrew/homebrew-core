class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "http://cristal.inria.fr/~fpottier/menhir/menhir-20180530.tar.gz"
  sha256 "a8cb2326790cf701b84966ea7aec644b67c0ed80293961a2b3a07082b7a05aa2"

  bottle do
    sha256 "db6101e87b983c730b1ebf784fd0f113928c8b499d8087d1297635498127a85e" => :high_sierra
    sha256 "c3e5451f4e72a35cbbe570d60ccb2739f51d7eed1a577c9f455405234d93e9f3" => :sierra
    sha256 "db712e783f7e3f6f40841e13f76e4ad4dc3d1ff60379329f1f05c8ca851670e0" => :el_capitan
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
