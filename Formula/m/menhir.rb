class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20260112/menhir-20260112.tar.bz2"
  sha256 "fd4a524805cadf612b46fefcc810c4c16a310e3e1ce8e2426dad577ac5d8bebc"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d7880aa4613694436f2bb4a5f33daf19209ba3b8b0db1b105d182702dd969857"
    sha256 cellar: :any,                 arm64_sequoia: "17a43530d99dd7507364f3fe1575a58da4bf666869e12409f8e10aaa5b39ec68"
    sha256 cellar: :any,                 arm64_sonoma:  "c29f065dc0160e0714922fea716b0823886d77eb2559ff071e7c4ad9ef37e7ea"
    sha256 cellar: :any,                 sonoma:        "a21ea4bbb3540d0195f369e45655ba026473a242eb5d7950b990e0ecabc798c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3eb175816cc65aa01edfb0ab6c1940835c3689496f6ac7de9af69836f891a758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcfed0fe7c4cb5e452c03e51d686af8e5574fc7f0274668e52e13bd05453e04b"
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
