class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "http://cristal.inria.fr/~fpottier/menhir/menhir-20180905.tar.gz"
  sha256 "82f3767290e39bf1ce3e260cd3cf486295891d57351cdccaedc6919000746750"

  bottle do
    sha256 "b13dc0c1405d56ffec4e511a58e729086626738e2b373dd3471086dc3d6c3562" => :mojave
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
