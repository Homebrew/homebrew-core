class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "http://camlp5.gforge.inria.fr/"
  url "https://github.com/camlp5/camlp5/archive/rel700.tar.gz"
  version "7.00"
  sha256 "0b252388e58f879c78c075b17fc8bf3714bc070d5914425bb3adfeefa9097cfd"
  revision 1
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    sha256 "b2f93d5871224736d340fe40ded5e903de22fc019912934487c5191a45bcb6e6" => :sierra
    sha256 "45ba40d54e809989fffcd86e13c3effebb0a1e98fdbc51953024f2268012a618" => :el_capitan
    sha256 "aefa23cc767d54dfd59f39702e44874692ef612499ba97532d42b40737a533dc" => :yosemite
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
