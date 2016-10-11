class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "http://camlp5.gforge.inria.fr/"
  url "http://camlp5.gforge.inria.fr/distrib/src/camlp5-6.16.tgz"
  mirror "https://ftp.ucsb.edu/pub/mirrors/linux/gentoo/distfiles/camlp5-6.16.tgz"
  mirror "https://mirror.csclub.uwaterloo.ca/gentoo-distfiles/distfiles/camlp5-6.16.tgz"
  mirror "https://mirror.netcologne.de/gentoo/distfiles/camlp5-6.16.tgz"
  sha256 "fd446cff6421f5144a521c7cecfdc7217b1424908186cddd3d5be543b35058b1"
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    sha256 "c3b0de27509d520db27d7ff2835b091fedee0568b0cb0b5d926ae2828377750c" => :sierra
    sha256 "9f38f3084632691b7b45bd26245a5f824b65f8058b9a343a0b27e07e23264168" => :el_capitan
    sha256 "3f142db90e8ba6d095249d1c741b6869c751c38a5a1a07daf0beeebf422b28d0" => :yosemite
    sha256 "19c58865719d70228380b7107377dbf4519b3a982612c5702fa7592c943fd864" => :mavericks
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
