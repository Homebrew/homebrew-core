class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/rel705.tar.gz"
  version "7.05"
  sha256 "ccc7afd2936c75cbee4aad58cd2ef8e7bf0dded556b91d76e4e462a27550ff12"
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    sha256 "155367db93088caaafa6b0f85900b41824d8938bf7ccad4435c3d86b758041d1" => :high_sierra
    sha256 "bba5a5f9b70461cea57dd24dc04a219d6bce1f9c51634eb84a2b4028d335b019" => :sierra
    sha256 "64380dceb3f1a68d984793d5e9b67e83c3e58687b81cf487def814398e9183d4" => :el_capitan
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
