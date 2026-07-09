class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20260209/menhir-20260209.tar.bz2"
  sha256 "06f6e571aadd7d66cc3da808052d9a65f8be96fe27e0ad7e57bbbf8c20f4a832"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1862c8df45f52dc404b17fe9273be393cd9a95915f2d286f27f9319fb0e3371a"
    sha256 cellar: :any,                 arm64_sequoia: "173d3774f8c1497230e9be8850443ac0783e36d9b84aa565f4bf5d1e8faab5f4"
    sha256 cellar: :any,                 arm64_sonoma:  "255ee4bfbeaa8d28092704f8d068877943b7d379e6e5fc5a2eec84b98724cdbe"
    sha256 cellar: :any,                 sonoma:        "8c7615312513871d4cf19ea6a1a5148992432b1df6118a11258503ebe63cf8f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fc0ee0e90cd8e7e838c1264e6e75f5b65f037c70252f9cd406157a61f2d6db5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b30a760335b79a8b54de203a47de4e1e66d93bf96551cb00ec1ddc234fd25d3"
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
