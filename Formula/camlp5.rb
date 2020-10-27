class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/rel713.tar.gz"
  version "7.13"
  sha256 "bc73a8810552fbd0c905364aba34dba46e3cadae483f89e7e39fa7f7d3be720c"
  license "BSD-3-Clause"
  head "https://github.com/camlp5/camlp5.git"

  livecheck do
    url :homepage
    regex(%r{The current distributed version is <b>v?(\d+(?:\.\d+)+)</b>}i)
  end

  bottle do
    sha256 "42db6069ff94f56ae402349dd6cfb2dd11dcf82bb8976eec981c8c1d4a1bebbc" => :catalina
    sha256 "27fbf9131d73480ad618b586ea34a54b2487d8a0b0265707a40bc1bc32f5f4a4" => :mojave
    sha256 "09d7960df4487c5bd0034ca7945d13957341c2053ed618313aed99f293734528" => :high_sierra
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
