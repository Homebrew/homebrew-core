class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20210310/menhir-20210310.tar.bz2"
  sha256 "93f08a009aa04d3f2e92a0cd6ca603b7103f4763a105f89549623e60b1d94081"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e47389477576808086e895005361300fafc93983815237597325d08ec8a9e6d2"
    sha256 cellar: :any, big_sur:       "2489afadf591e3052f81fc9219911e4c6d466d4933ea2a9fd44032f571e1abe4"
    sha256 cellar: :any, catalina:      "b5a6e90d021aa79d5b1b3f270bc4773b9fb06070c14ca1145b8ea04996ff7e8f"
    sha256 cellar: :any, mojave:        "4d932e5fd011872bdc738b62ea7972a3ca6352aa5b7f74b59c3a5a3f9d4bea3e"
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
