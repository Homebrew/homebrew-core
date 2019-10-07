class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/rel710.tar.gz"
  version "7.10"
  sha256 "83dff83d33ee9b70cd1b9d8d365db63a118201e5feb6aab49d9d3b1d62621784"
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    sha256 "6c8c1d3f0239f92b455a1cb801e45ba6b4cb7f9021a48f36ccade3f0a9c3a679" => :catalina
    sha256 "f20e753e899bf8d6fedf51284a5ffeabfffc3da01151d07ef6f040888ffd159a" => :mojave
    sha256 "c6d3725bb7e79d77c00b1f430abad3f8542563eab79429eaa7f0420138a38d94" => :high_sierra
    sha256 "6246f8aa046ae45095f20ad3c839b317d284c7c4a27b6d572b8bb3256d9a5c19" => :sierra
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
