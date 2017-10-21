class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/rel702.tar.gz"
  version "7.02"
  sha256 "2a4aeb5ab480b3229df00275eef4fa4a454bad2f3b2f298493c927be523bf61b"
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    sha256 "a4a39223239a56e9f851f73508a58903bce18138edfd16149f1b549c67b11c4a" => :high_sierra
    sha256 "1a877325c6d39e612b7c8b96ee6e7ddf442fefe1f2f5f4a4396dd3e0ba8165c2" => :sierra
    sha256 "a73018be2cde5d90bdb3da016e6b6b78cc01ac76aad398bbf8878d4602fb9a72" => :el_capitan
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
