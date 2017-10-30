class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/rel703.tar.gz"
  version "7.03"
  sha256 "c13d0a957a8e70627e1900ca25243b5e8da042bbda9eaa9e7d06955c0e3df21a"
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    sha256 "376e0797322edad251db4a9cb83f573c2ff9876ec3a19f7c8ff3f1f0eeb983c8" => :high_sierra
    sha256 "01187509e78303501734480b02d6b171a583b1fb738a8969c5a6c624d8578d3b" => :sierra
    sha256 "3aef66595f46b985bc6c2eca6555a9aaf19e82f83ee17079d69cc471015d6df1" => :el_capitan
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
