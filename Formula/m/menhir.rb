class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20250912/menhir-20250912.tar.bz2"
  sha256 "e69d5133d37579a481775e6e8bd0232f1ca92d582234d6f3760855b99dc8ffb5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8e529725dc34ba991c8b1305a39b76b7c38a21a8c872370289a0ed4f98b478a9"
    sha256 cellar: :any,                 arm64_sequoia: "547e0d082c253278979a586c24cc647d2ccab641148077c6c25d073080b75b5c"
    sha256 cellar: :any,                 arm64_sonoma:  "bdfcf60b1735fd0bd6b73ebcf8ddb9d1fb4942dc4c3da793a01494f5e8cde807"
    sha256 cellar: :any,                 sonoma:        "05c5e81dfaa5fee6357ba4d996c18f050c6a33c1705855034efd582e6b8fa38c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9fe973e5b0bdb53ecc837ea6aaeaefae1a79f72c9898c2e684ef1e02e169903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f2dcb8edac670d5ab54df139e450bf73a2cfe0af79677c691472e2df88dfe04"
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
