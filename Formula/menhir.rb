class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20210419/menhir-20210419.tar.bz2"
  sha256 "6024d195994e86d24795d3bc2aeec5e8884bc13af1dc107fdebc047129d106e9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "b37a344321702300cbbf18c407b3e1fce365a19ce412e3cec8b016293c654114"
    sha256 cellar: :any,                 big_sur:       "f42d182ab5cc9e8d14464cfa1d7c1c7fb8e1a563b17006793d420424d7070f0e"
    sha256 cellar: :any,                 catalina:      "ddbd691df178056fa2aaa1980aaec960d5259dbfe28037a4417b4f35310e03e6"
    sha256 cellar: :any,                 mojave:        "a016bd58f69c0b05e9a0141a86086193726773719e03a7378a0afbca70cf3ec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c77f2d2108fa7a07fb9f3e15755874db7b3586c0fc5114040373bfe2add4803d"
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
