class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20210310/menhir-20210310.tar.bz2"
  sha256 "93f08a009aa04d3f2e92a0cd6ca603b7103f4763a105f89549623e60b1d94081"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "71abc8ff15028ebf565663d0257f1519ff198443b0566803528c6567ce746e3c"
    sha256 cellar: :any, big_sur:       "479036ccccb72f46c58c7bc2c8b7d9173d10fa29d118a3c0531fc67709674abe"
    sha256 cellar: :any, catalina:      "74a37a76ab76d7f9aa88c0e3f07fa71c493bdf34e82aacfbe4468886c28edd72"
    sha256 cellar: :any, mojave:        "37d4733a281b5e1f3413276227a7ede9d9789726a728749d50b6011fa352e700"
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
