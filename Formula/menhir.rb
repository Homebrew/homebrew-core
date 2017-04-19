class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "http://cristal.inria.fr/~fpottier/menhir/menhir-20170418.tar.gz"
  sha256 "31deadeef2129ffcbdd78717007e13f87031432e6c3601f7e829bb0e5f9c7d2b"

  bottle do
    sha256 "f8211e8e59700a24c4e77d3c5c6cf4fb7dffdd259667d567383823629e75293d" => :sierra
    sha256 "4d9cbf80eda8ff59a7fc6c25e96eefe224868bbf7347bbb6efafd74c85f98c03" => :el_capitan
    sha256 "e710431bf1a15351736dcee361b5d7d7694456c5e2fc262b5e395ef48c16f5ef" => :yosemite
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
