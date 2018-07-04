class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/rel706.tar.gz"
  version "7.06"
  sha256 "bea3fba40305b6299a4a65a26f8e1f1caf844abec61588ff1c500e9c05047922"
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    sha256 "566b2e7ca2141d339b5fa51fee9e7371c94f87a2909e23eaa9aa1cf782a80124" => :high_sierra
    sha256 "9aef8f09878f0f2b9de335ba67ac52ffb4be851b1efe612fdd7d261ac5cfc644" => :sierra
    sha256 "3777de238c30931a204387dcca9f877e94b8ad353c56b91b569067d84bb9a962" => :el_capitan
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
    (lib/"ocaml/camlp5").install "etc/META"
  end

  test do
    (testpath/"hi.ml").write "print_endline \"Hi!\";;"
    assert_equal "let _ = print_endline \"Hi!\"", shell_output("#{bin}/camlp5 #{lib}/ocaml/camlp5/pa_o.cmo #{lib}/ocaml/camlp5/pr_o.cmo hi.ml")
  end
end
