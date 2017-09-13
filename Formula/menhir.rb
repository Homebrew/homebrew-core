class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "http://cristal.inria.fr/~fpottier/menhir/menhir-20170712.tar.gz"
  sha256 "ca482d690052343d6cb9452433248a0a92cc8bfc8fa529dc313220c9d7c0d000"

  bottle do
    sha256 "57489d76a5f717fda9b2d78f6c049ad924f823f8536b11eb3e3aee2449207a3d" => :sierra
    sha256 "9d17da07dfecdbfc7bc3d26c74d1c92f6d5a0e546e6e9a2e4db1288ce5cdcbbc" => :el_capitan
    sha256 "fab74e052f76b06d9511e3cd3d68caed29027f0994016791441b009e09f7798c" => :yosemite
  end

  depends_on "ocamlbuild" => :build
  depends_on "ocaml"

  def install
    system "make", "PREFIX=#{prefix}", "all"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"test.mly").write <<-EOS.undent
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
    assert File.exist? "test.ml"
    assert File.exist? "test.mli"
  end
end
