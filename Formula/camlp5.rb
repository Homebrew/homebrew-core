class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/rel712.tar.gz"
  version "7.12"
  sha256 "fc4b50b9d917c2f844b909bdfd55735f3f658e32a415f0decc1c265bf3af42be"
  license "BSD-3-Clause"
  head "https://github.com/camlp5/camlp5.git"

  bottle do
    sha256 "37dddf4bb25b87697f67da03bafce93b5ed258468e4ca3381f92a76a76c1b956" => :catalina
    sha256 "b2fddd39a3d20529598983ab9a1b1b80c86e228111e613501a71a223bf0d5694" => :mojave
    sha256 "ab802383d18fa5a34dc9dc1abd3d264c006693df3205a53c4be17cca6e5f223d" => :high_sierra
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
