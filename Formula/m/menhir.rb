class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20260209/menhir-20260209.tar.bz2"
  sha256 "06f6e571aadd7d66cc3da808052d9a65f8be96fe27e0ad7e57bbbf8c20f4a832"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d1a66c4b6941afb80b0aadb164785119b861126372ed35ffbe676fb64fe8661f"
    sha256 cellar: :any, arm64_sequoia: "cf4092141bf3aa6c254724e787b839e63bfa29b4d1f8bf6897e5d9c12ed7d768"
    sha256 cellar: :any, arm64_sonoma:  "b83889d4561b8329dfebd154a8253965dc7e7c1686e09fe4e68d543e1ac1e0e7"
    sha256 cellar: :any, sonoma:        "c6e4c120b6d81d5744a1413cd5f2db5bf947997973378a6b59f33cdf7b448302"
    sha256 cellar: :any, arm64_linux:   "dae63b81d9880d515ee22f6bbb580d7b56df526f2ce9a0e4557866cbba37fbcd"
    sha256 cellar: :any, x86_64_linux:  "a0eb1b47d06bd256da1f007f63f02cb743797a0cbec9d0726233a1a3f365f97d"
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
