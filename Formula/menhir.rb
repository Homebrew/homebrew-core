class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "http://cristal.inria.fr/~fpottier/menhir/menhir-20171222.tar.gz"
  sha256 "3958ef6d317548c7776a25a13a48855fc1972d660c211ebec7e797b5bec0f47e"

  bottle do
    sha256 "1b4f7298c9130c28feb9d7122e1dd08a7e734ce3040a720e1be2006458505670" => :high_sierra
    sha256 "5d6c6809d1fd545c507ee3bba42f0b3df84f302b2f5ac723a64bdd565923b206" => :sierra
    sha256 "42d182742c539f018ed9648246529c4afb88712c01786d8de270625aded49f3c" => :el_capitan
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
