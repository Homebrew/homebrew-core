class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20200211/menhir-20200211.tar.bz2"
  sha256 "003df5e553660a8bdeb9a9f45185f8c5dfa63f85f361ad494dbfa81eed34acbd"

  bottle do
    cellar :any
    sha256 "7cea53cab9c67efe36ef26f903346b0f7ceac69865583580bef9de50583b1cfc" => :catalina
    sha256 "bcd74e6ed3a0eaa8017f32aaaa310f40b14fbaaa4f26c42c6a1a6316115f2610" => :mojave
    sha256 "266d39e5ffeffe92fd04d0e78c404dfdc71cea5ca433c4e62f9c6c79dfac5806" => :high_sierra
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
