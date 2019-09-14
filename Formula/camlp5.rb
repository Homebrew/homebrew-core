class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/rel710.tar.gz"
  version "7.10"
  sha256 "83dff83d33ee9b70cd1b9d8d365db63a118201e5feb6aab49d9d3b1d62621784"
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    sha256 "6d8f3f5e9339b778a05059d63e2a8d3b7351252a5efe41cbc2c5ab67e0b6b98f" => :mojave
    sha256 "ade9b0f64be248782b2e04b3ef28e5ae4459f13dd96141bc38f401f4fb342054" => :high_sierra
    sha256 "21ac12d7eb072cd484524db8e31b616e515667597a87b0cc3abbd1dd81d75d06" => :sierra
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
