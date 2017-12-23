class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "http://cristal.inria.fr/~fpottier/menhir/menhir-20171222.tar.gz"
  sha256 "3958ef6d317548c7776a25a13a48855fc1972d660c211ebec7e797b5bec0f47e"

  bottle do
    sha256 "314f530185298fcfad36331846e019f34866375c958cb6b61180263eb410bb3b" => :high_sierra
    sha256 "00816e8642823c64930316235f1d24a83eb6189825d5d49454fc6aea8b4bae53" => :sierra
    sha256 "7f66544bf41a1419eb3863bd9ce165c4ef765d0730386c64844e3768c085d4e3" => :el_capitan
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
