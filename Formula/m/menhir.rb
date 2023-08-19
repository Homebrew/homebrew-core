class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20230608/menhir-20230608.tar.bz2"
  sha256 "6fff24b0e1bca2143a774357dcda17ba367a6d23fadd9d7df52774f904dae2a9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b5f3471fdeedef8360e4ef1a220787993578205fdf64b34bfe52eaf426ad40a0"
    sha256 cellar: :any,                 arm64_monterey: "b092e36031f47030e59839d5fd05d321317ace2cd20a83f0ed952a416bd0a90e"
    sha256 cellar: :any,                 arm64_big_sur:  "14f19b612756c58d8c935598f6f6a8f7b11f405a1cb3b7dbad0fe6063e941f3f"
    sha256 cellar: :any,                 ventura:        "03f6d47c1c894c0892a536dc0abcf744039b747bbe707880024d491c16e8a9ac"
    sha256 cellar: :any,                 monterey:       "17a7165e6c26f622e431953ab5a9723b36035d31dc2296768dda298f5b0995e0"
    sha256 cellar: :any,                 big_sur:        "d1cace7fa759e156a78d1e3f2e71723bb0971e549a64c16dbea5f206ee028aea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8aba8e33a8f0746020d10440af25b25eda2d83a414bdcda1ffabb51fa5b5ec0b"
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
