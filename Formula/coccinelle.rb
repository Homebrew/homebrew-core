class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "http://coccinelle.lip6.fr/"
  url "http://coccinelle.lip6.fr/distrib/coccinelle-1.0.6.tgz"
  sha256 "8452ed265c209dae99cbb33b67bc7912e72f8bca1e24f33f1a88ba3d7985e909"
  revision 1

  bottle do
    sha256 "52b8fd8d7e7c86c13eb407b0110ad3bac610762324bdc2995f58c9dab2efb711" => :sierra
    sha256 "11135808a7d74af55ae74a548a9ed92eaecc6b7c5ba2b201136ef94fcf6ea07b" => :el_capitan
    sha256 "be0bba4bdc821f24c031902d8e1bcfe72e6f208cbd728527a506f59b914da526" => :yosemite
  end

  depends_on "ocaml"
  depends_on "camlp4"
  depends_on "opam" => :build
  depends_on "hevea" => :build

  def install
    opamroot = buildpath/"opamroot"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"
    system "opam", "init", "--no-setup"
    system "opam", "install", "ocamlfind"
    system "./configure", "--disable-dependency-tracking",
                          "--enable-release",
                          "--enable-ocaml",
                          "--enable-opt",
                          "--enable-ocaml",
                          "--with-pdflatex=no",
                          "--prefix=#{prefix}"
    system "opam", "config", "exec", "--", "make"
    system "make", "install"
  end
end
