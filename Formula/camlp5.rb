class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "http://camlp5.gforge.inria.fr/"
  url "https://github.com/camlp5/camlp5/archive/rel617.tar.gz"
  version "6.17"
  sha256 "8fa2a46a7030b1194862650cbb71ab52a10a0174890560a8b6edf236f8937414"
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    sha256 "d91457bf0c22c9800157108f6bc2e4d7d0b3c13802b209798e2e927383fa776f" => :sierra
    sha256 "9b0b537f3acd5be4f4cce7e1c94406cb164b2fb9cc4fad4d5c0dd1f3067692f8" => :el_capitan
    sha256 "23def55a97deaac228590e894746a2384e0cb2a3704cc8aa83cb18c302127d62" => :yosemite
  end

  deprecated_option "strict" => "with-strict"
  option "with-strict", "Compile in strict mode (not recommended)"
  option "with-tex", "Install the pdf, ps, and tex documentation"
  option "with-doc", "Install the html and info documentation"

  depends_on "ocaml"
  depends_on :tex => [:build, :optional]
  depends_on "ghostscript" => :build if build.with?("tex")
  depends_on "gnu-sed" => :build if build.with?("doc") || build.with?("tex")

  def install
    args = ["--prefix", prefix, "--mandir", man]
    args << "--transitional" if build.without? "strict"

    system "./configure", *args
    system "make", "world.opt"
    system "make", "install"

    if build.with?("doc") || build.with?("tex")
      ENV.deparallelize
      ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
      cd "doc/htmlp"
      if build.with? "doc"
        system "make" # outputs the html version of the docs in ../html
        system "make", "info"
        doc.install "../html", Dir["camlp5.info*"]
      end
      if build.with? "tex"
        inreplace "Makefile", "ps2pdf", Formula["ghostscript"].opt_bin/"ps2pdf"
        system "make", "tex", "ps", "pdf"
        doc.install "camlp5.tex", "camlp5.ps", "camlp5.pdf"
      end
    end
  end

  test do
    (testpath/"hi.ml").write "print_endline \"Hi!\";;"
    assert_equal "let _ = print_endline \"Hi!\"", shell_output("#{bin}/camlp5 #{lib}/ocaml/camlp5/pa_o.cmo #{lib}/ocaml/camlp5/pr_o.cmo hi.ml")
  end
end
