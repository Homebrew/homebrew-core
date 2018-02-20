class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/rel704.tar.gz"
  version "7.04"
  sha256 "4d28171121db1ea6f54d409cf959aa4d4359c13b957eb5a14e4fe37cc58243a8"
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    sha256 "7e46185b3b6a84685e244c0d0d58c576891223da68b69aefca4fb482ba801318" => :high_sierra
    sha256 "4dcbace80511a84ff99022673115e9f198636eaa02d7644f9568c7ea98696048" => :sierra
    sha256 "95ff8cb79b9ba822d42c32deb1af2467d328d6599d184ec36a11ee41fe224335" => :el_capitan
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
