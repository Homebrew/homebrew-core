class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20260209/menhir-20260209.tar.bz2"
  sha256 "06f6e571aadd7d66cc3da808052d9a65f8be96fe27e0ad7e57bbbf8c20f4a832"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "87d1a6f7fa151ddf1de28d9995e37e16e2dc524e9535596d183142414076a7b5"
    sha256 cellar: :any, arm64_tahoe:       "43af046448515ba9704d2d1aaa83c11c5ca6fb6e0837c336533ca84f75717dd7"
    sha256 cellar: :any, arm64_sequoia:     "e92475c1bc5431eb558e055bcc2ed6b849aa8dc0b4c195f2311da317c7ebce8f"
    sha256 cellar: :any, arm64_linux:       "a8da683ffae4530db882842956e605b8766c84ac5d5ec65a6915395d63081c57"
    sha256 cellar: :any, x86_64_linux:      "817623b4c127287e8c5e2206c0d8cf127ebd3e9736b3d65fe9a01d61bc19d815"
  end

  depends_on "dune" => :build
  depends_on "ocamlbuild" => :build
  depends_on "ocaml"

  def install
    # Use the release profile like opam so `menhirLib` matches copies bundled by other formulae
    system "dune", "build", "--release", "@install"
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
