class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/rel708.tar.gz"
  version "7.08"
  sha256 "46e67d8e36e5e4558c414f0b569532a33d3a12d7120ffdc474a6b3da1bfff163"
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    sha256 "bc41d8d05b58ea18887f802e63037dc77aacb77014fbd37f375459cf198b1a02" => :mojave
    sha256 "46b26065975d0d1e8769ca94425792146c142d1f92658ac33ce14840e56c55d1" => :high_sierra
    sha256 "048042a01ab67acb0aad31a5d8c9647b497a13fa3299f8cd85e3bcb664f52566" => :sierra
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
