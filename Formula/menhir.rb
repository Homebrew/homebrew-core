class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "http://cristal.inria.fr/~fpottier/menhir/menhir-20180703.tar.gz"
  sha256 "ab5f16632e81fb67844becde994dbdd6fd875b3a9c799a275af8083f4f2d9b9b"

  bottle do
    sha256 "66c3cd9edeb38e0dbbbb7fcd73a281e26f82db6a922e2945c690855ff9654b5e" => :high_sierra
    sha256 "58af3454e55f435827f49243ab71fc05a1a529981b818b78eddab88fa5c5e87e" => :sierra
    sha256 "ee0ad38aa7dc7c44296f33a439ef6c7b9a007c453ef05f84fb5035dfd4e5ef9d" => :el_capitan
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
