class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "http://cristal.inria.fr/~fpottier/menhir/menhir-20170712.tar.gz"
  sha256 "ca482d690052343d6cb9452433248a0a92cc8bfc8fa529dc313220c9d7c0d000"

  bottle do
    sha256 "f0484baf19eb08a48c91773396d558e1f27a5fab7c0d7d4f09c66687ac97d843" => :sierra
    sha256 "fec8225bfff56007654c82eb82fd440950a8e23674a6a1164012d41c0bcd6de6" => :el_capitan
    sha256 "f7a05237fae710129a03862d8bcd0339f42e76be5b2ef65794b3c00456d6dc47" => :yosemite
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
