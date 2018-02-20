class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/rel704.tar.gz"
  version "7.04"
  sha256 "4d28171121db1ea6f54d409cf959aa4d4359c13b957eb5a14e4fe37cc58243a8"
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    sha256 "e3d1c8337409ff5bcf269bcafb092a2dce4289a741af8bab862de7eab535fda0" => :high_sierra
    sha256 "77bc6f9cd2423d4b42829de20b940eac6894c7fe35d44e6689dbda08cecfc5a4" => :sierra
    sha256 "ba622de195e13610286907beb9ec432b8f1b3bdf9767fac46a1c1c6d25b7dd68" => :el_capitan
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
