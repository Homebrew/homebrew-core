class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/rel708.tar.gz"
  version "7.08"
  sha256 "46e67d8e36e5e4558c414f0b569532a33d3a12d7120ffdc474a6b3da1bfff163"
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    sha256 "ab7a68890d905e84438bedd7f0e399392dea7cea97b6549e499b85b5ca92a9cf" => :mojave
    sha256 "b11b7b41528fbb84be0f599638eab661176d515dcecdff847e2b247f412d328e" => :high_sierra
    sha256 "cd076fd8bcdaee3fcf789915df1f98500ba2d703764426e63aa5dd6b2fa7dc70" => :sierra
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
