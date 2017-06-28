class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "http://cristal.inria.fr/~fpottier/menhir/menhir-20170607.tar.gz"
  sha256 "00caa66ed0d1544defda24539f2ca1d37b92120e0575aafc5fcabd8e5364ce61"
  revision 1

  bottle do
    sha256 "45ea2725cf33b536e5c7026a77829a7ef06c47bd8ba997365271e52e3ab106b0" => :sierra
    sha256 "940c0df682722ffc3be6dd84c067570dfa974b077cb23df390c11717f3f66fde" => :el_capitan
    sha256 "39577be729abb9ceccd3ca9b4d674840c2873f307228b8772c920b02af983004" => :yosemite
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
