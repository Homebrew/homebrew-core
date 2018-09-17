class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "http://cristal.inria.fr/~fpottier/menhir/menhir-20180905.tar.gz"
  sha256 "82f3767290e39bf1ce3e260cd3cf486295891d57351cdccaedc6919000746750"

  bottle do
    sha256 "5ce9eda23c034dc818034a29784cb110b013bf7d34fcb03646c2fbc2a4e2fdc0" => :mojave
    sha256 "8465bd1f845ed9e5cd17d493409bb5f231274acf07f3e2dacd949f5b9ef4e14c" => :high_sierra
    sha256 "b334910852aff3c273f57cfc9361e99595bd6ff3ce38a2bc61b8675ec4e9395b" => :sierra
    sha256 "0c261facd1c50797c1b2ae1cd0db1fb921a7de568c84db9d60ea4b7aa5229dd4" => :el_capitan
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
