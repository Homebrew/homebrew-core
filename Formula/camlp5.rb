class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/rel8.00.tar.gz"
  sha256 "906d5325798cd0985a634e9b6b5c76c6810f3f3b8e98b80a7c30b899082c2332"
  license "BSD-3-Clause"
  head "https://github.com/camlp5/camlp5.git"

  livecheck do
    url :homepage
    regex(%r{The current distributed version is <b>v?(\d+(?:\.\d+)+)</b>}i)
  end

  bottle do
    sha256 "f848f21e1d3fdead2126c51499a35412f3fe42248a6b639d88a8183affe14050" => :big_sur
    sha256 "625b0c1b99bc64c224e257419529172a0b84e762d80b330153d61abbeebd67d6" => :catalina
    sha256 "bb908676387d9d1b8d87a5948a1d12b36ca46868802cd6b32f9f7fa2d970a3db" => :mojave
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
