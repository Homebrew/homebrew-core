class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20231231/menhir-20231231.tar.bz2"
  sha256 "fb76a37b84e28acd3ecf58efea3abc8c7a9a70987a44915837e81093a7853d3a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "182247d95722654249f03821183168020c5fd2c8dfc2cb537f7849113d55077f"
    sha256 cellar: :any,                 arm64_ventura:  "a6f67e1df35d4958923fae7e847f799d81710ac298b618bd08f4a643b8a03b89"
    sha256 cellar: :any,                 arm64_monterey: "77285973f5aff863fe702d1b6e57eb32528718e17da0cbfebc8f88da88f00674"
    sha256 cellar: :any,                 sonoma:         "8cb64eaf45aeed6fa2a9f13b7d88a749efb47e79fad18647a7b9525161e536c5"
    sha256 cellar: :any,                 ventura:        "30f0b2a803560c18bebeb851c222c1a8352e7130045a02e3680f7aff40d5d180"
    sha256 cellar: :any,                 monterey:       "51b8a1f0d7873e4f578f75e1102ac09f6026c264b52add86d9ec8c25fa9a5348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9da631e1b1809bb851303ab71ebeb80319064d1672e0511d605869c29686339"
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
