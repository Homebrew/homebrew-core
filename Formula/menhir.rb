class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20210929/menhir-20210929.tar.bz2"
  sha256 "2775a51f5f515fc4ec6088f06f5ad8149dc7e0f7019002355c09c1d5f96e7263"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "90ec00c926e42b81ce0571955fd748fa45fe59f76885d5b99084af73868cfe75"
    sha256 cellar: :any,                 arm64_big_sur:  "39c8b455817f7a124d0a5cd8b576ba9de5243dfa5486d3f803b7e3c8e36fd22f"
    sha256 cellar: :any,                 monterey:       "921cfc82b42dc804a7fde786567c8341799cfd6c47d9c41bdb2f9af5375563e2"
    sha256 cellar: :any,                 big_sur:        "20086a5d407eaf8162f56dd1f9225491db6b987db6f00ecc9aa5a966cdc411e8"
    sha256 cellar: :any,                 catalina:       "793848617f63013de384e88dc5ac2201b1d8cc2ac80e89f4b26b9f33661262f9"
    sha256 cellar: :any,                 mojave:         "ab05cc4ce18b62a041365fd4d34f04dc55ae756845288dffe47786a0f2844efc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efdd4cbdf040c3dfec55f9fd0b256450cc0c678d30e874df912b429f3dce06fc"
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
