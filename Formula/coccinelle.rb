class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "http://coccinelle.lip6.fr/"
  url "http://coccinelle.lip6.fr/distrib/coccinelle-1.0.6.tgz"
  sha256 "8452ed265c209dae99cbb33b67bc7912e72f8bca1e24f33f1a88ba3d7985e909"
  revision 1

  bottle do
    sha256 "0693fefe1f7978255ade853c00cf6a1e0d8c7811113ca1aa80a7cef9c12c6279" => :sierra
    sha256 "35845252c3b5b162b63ad09fb21d286728db6a1bae6ace3e159a645123562090" => :el_capitan
    sha256 "63733fef13eb94a22d714476ac9e59fb3765e515b79c4467a57b14338d3fa96f" => :yosemite
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
