class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20240715/menhir-20240715.tar.bz2"
  sha256 "b986cfb9f30d4955e52387b37f56bc642b0be8962b1f64b134e878b30a3fe640"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "14dd16a69a570a455240d296e6f44805c9ae87eeb98b54daf50d5201a3b031eb"
    sha256 cellar: :any,                 arm64_sonoma:   "981738a0ed04e59a302c4195b157870e59dc8f7be663f1bb0bd9493cbdcf9277"
    sha256 cellar: :any,                 arm64_ventura:  "83193b946be4684240e7ccfdf7cb722fb1791e0dfbea95bc47f7afa2c347f61c"
    sha256 cellar: :any,                 arm64_monterey: "a32cf574977558f2dfa79b986e7a20f7340a32b0d998d65759e7b7db45d1d5c0"
    sha256 cellar: :any,                 sonoma:         "5c51478563460c4bf57f48a599f4f6d3cec0374734e163f1b05dcaf1a2d14acd"
    sha256 cellar: :any,                 ventura:        "ff8d04832ebadaec926d1ceffb2188a32e5ed8dfa500175af6afdd338b0be10d"
    sha256 cellar: :any,                 monterey:       "8548accbcc37dbf510d010b5a664c6645b9407af5995be09a8ef24c1653bf5f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7009e018d3ce59a82b4ef105f7dd27dd2dade641f081352544273bbfd35209dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b59171d340c6db652b67aaa74357024684510313d81be23b6298b0d6cd5c61e3"
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

    system bin/"menhir", "--dump", "--explain", "--infer", "test.mly"
    assert_path_exists testpath/"test.ml"
    assert_path_exists testpath/"test.mli"
  end
end
