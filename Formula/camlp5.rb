class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/rel702.tar.gz"
  version "7.02"
  sha256 "2a4aeb5ab480b3229df00275eef4fa4a454bad2f3b2f298493c927be523bf61b"
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    sha256 "8a8d01278a2f24112868a5b78bb74547b61652fa6d233728a7b6f0d2fe65182f" => :high_sierra
    sha256 "3e09643461db1f8c260098232c16819d120f6f6808c50df1854d5143c54cbeb3" => :sierra
    sha256 "8294ff79a57b8fa4394e3666f920b11a4732cc2d1af1081e1edb2b9c9b153122" => :el_capitan
    sha256 "724d78905bd0c4ee316025f0bf255209ac3657c2e915cddf8c26bb1d1e88ae2c" => :yosemite
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
