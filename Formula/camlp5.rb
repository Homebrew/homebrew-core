class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/rel711.tar.gz"
  version "7.11"
  sha256 "a048b8e0feb2a1058187824fc9cb6b55f2c5b788c43c15d6db090d789c7121ba"
  revision 1
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    sha256 "9459b0d978fbf36ab15bbbd21665b4ad7b2f95f2e615c04593ddc9ceffc13bed" => :catalina
    sha256 "74fc5fc46cb0024df90bf13cfbfc9d97aa7db46169b13a512e7a167e4efa3a55" => :mojave
    sha256 "761fd3f625d47bd7c4e16dc17c47b58a371361227e76ccf8a79bb012d6a0813c" => :high_sierra
  end

  depends_on "ocaml"

  def install
    system "./configure", "--prefix", prefix, "--mandir", man
    system "make", "world.opt"
    system "make", "install"
    (lib/"ocaml/camlp5").install "etc/META"
  end

  test do
    ocaml = Formula["ocaml"]
    (testpath/"hi.ml").write "print_endline \"Hi!\";;"
    assert_equal "let _ = print_endline \"Hi!\"",
      # The purpose of linking with the file "bigarray.cma" is to ensure that the
      # ocaml files are in sync with the camlp5 files.  If camlp5 has been
      # compiled with an older version of the ocaml compiler, then an error
      # "interface mismatch" will occur.
      shell_output("#{bin}/camlp5 #{lib}/ocaml/camlp5/pa_o.cmo #{lib}/ocaml/camlp5/pr_o.cmo #{ocaml.opt_lib}/ocaml/bigarray.cma hi.ml")
  end
end
