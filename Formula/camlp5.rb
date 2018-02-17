class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/rel703.tar.gz"
  version "7.03"
  sha256 "c13d0a957a8e70627e1900ca25243b5e8da042bbda9eaa9e7d06955c0e3df21a"
  revision 2
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    sha256 "c2159630c54f7bad58b9417eb0c92514cac1d950afc0e3143c5ee3212cff3baf" => :high_sierra
    sha256 "fbea5b4bc60b78bad1ecab18750fc45e7105f09274c7493c393ac38005ecc4fb" => :sierra
    sha256 "16cced0fbb0ccbd4eabecaca68f9dd9a121cea46b917c9eca061d782823471c6" => :el_capitan
  end

  deprecated_option "strict" => "with-strict"
  option "with-strict", "Compile in strict mode (not recommended)"

  depends_on "ocaml"

  def install
    # Upstream issue from 16 Feb 2018 "4.06.1 compatibility"
    cp_r "ocaml_stuff/4.06.0", "ocaml_stuff/4.06.1"
    cp "ocaml_src/lib/versdep/4.06.0.ml", "ocaml_src/lib/versdep/4.06.1.ml"

    args = ["--prefix", prefix, "--mandir", man]
    args << "--transitional" if build.without? "strict"

    system "./configure", *args
    system "make", "world.opt"
    system "make", "install"
  end

  test do
    (testpath/"hi.ml").write "print_endline \"Hi!\";;"
    assert_equal "let _ = print_endline \"Hi!\"", shell_output("#{bin}/camlp5 #{lib}/ocaml/camlp5/pa_o.cmo #{lib}/ocaml/camlp5/pr_o.cmo hi.ml")
  end
end
