class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/rel712.tar.gz"
  version "7.12"
  sha256 "fc4b50b9d917c2f844b909bdfd55735f3f658e32a415f0decc1c265bf3af42be"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/camlp5/camlp5.git"

  livecheck do
    url :homepage
    regex(%r{The current distributed version is <b>v?(\d+(?:\.\d+)+)</b>}i)
  end

  bottle do
    sha256 "0fc4737c1395d1ef602b2e8c39ea759717c2315f8978a6d59eff0486a7b6f5b1" => :catalina
    sha256 "873bd9b0c0155fd2eadcfaf021e6f0fc2667790aac60dc756efe3383795af0e2" => :mojave
    sha256 "40965450f249c2485e737c20a00efc960508da83bc3d7989dbf1341729deb5c6" => :high_sierra
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
