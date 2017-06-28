class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "http://camlp5.gforge.inria.fr/"
  url "https://github.com/camlp5/camlp5/archive/rel700.tar.gz"
  version "7.00"
  sha256 "0b252388e58f879c78c075b17fc8bf3714bc070d5914425bb3adfeefa9097cfd"
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    sha256 "480bf967c02a550117ae945f321e0f8d7e27f79e560cdde9586b8f6369cd800e" => :sierra
    sha256 "5928dd616876616688800fd64ecdbd87af154fe6b9bc03037007f30da35df004" => :el_capitan
    sha256 "21ba483dffcf1adec6d71e2849477f71eb8144f1c7902543c5c1f6e0b3159061" => :yosemite
  end

  deprecated_option "strict" => "with-strict"
  option "with-strict", "Compile in strict mode (not recommended)"

  depends_on "ocaml"

  def install
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
