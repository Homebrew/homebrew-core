class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20200612/menhir-20200612.tar.bz2"
  sha256 "37a40ff261973cb1403ac3b16254cd2424e39e4e9f9bb4b6feb12b27aa6f29a2"

  bottle do
    cellar :any
    sha256 "1c4c5bb9dcfc9b9409dc4689e42d3baf31567e05abaf4ef6934a38e030a0b766" => :catalina
    sha256 "2d4de775a3370a7f3d873c4d452b60041275a9c78cc0f1098f4177092434bf6f" => :mojave
    sha256 "28bbd37dce6e29ed763b37ada1eea4ce010da2490cce0ea77b91122251e429f8" => :high_sierra
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
