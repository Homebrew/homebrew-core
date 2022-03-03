class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20220210/menhir-20220210.tar.bz2"
  sha256 "767d7dfb1ed0d85cb19d5aef38912846b50df36751be558b0af342ccab0b1b47"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "034b3aeab807e0f5c9b61b1ac62937cab695e39c3cf9f6cd3b024687ff963822"
    sha256 cellar: :any,                 arm64_big_sur:  "b5cf9ea01bd4ef559ce640dddf2bbc4602b9e5726d2d1d198a9a6a41d78f631f"
    sha256 cellar: :any,                 monterey:       "25465835b11b2d3aa42a82587acebb885b8d6c9329fb4d78d746964bbf1d757b"
    sha256 cellar: :any,                 big_sur:        "a7e520e7f276a33543b8b267b8f66bdd9173c627ae2d25c49012ee2d6e690848"
    sha256 cellar: :any,                 catalina:       "d5d243ea886ec400aa0eb78576fa3879e991e1265b52abf408cc02034efe4e3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e6da4390a6dcf83abd5bcfe897946de7f7dd0a7a30ebe5f2eb08a7a32b521be"
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
