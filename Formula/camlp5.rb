class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/rel711.tar.gz"
  version "7.11"
  sha256 "a048b8e0feb2a1058187824fc9cb6b55f2c5b788c43c15d6db090d789c7121ba"
  revision 1
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    sha256 "27dfeccce3f11fd680a3f7d5854ee35779161f099e6e295fe17c036d48636f7f" => :catalina
    sha256 "59a07c3081aa5f7503036b74cb89f0d854778638b32eaedcc5d00e58c1b1ef30" => :mojave
    sha256 "137a5bf449780d553bf30c00782c6f07d0fb3815125bce47c0391fc20449d991" => :high_sierra
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
      shell_output("#{bin}/camlp5 #{lib}/ocaml/camlp5/pa_o.cmo #{lib}/ocaml/camlp5/pr_o.cmo " \
                   "#{ocaml.opt_lib}/ocaml/bigarray.cma hi.ml")
  end
end
