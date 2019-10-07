class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "http://download.camlcity.org/download/findlib-1.8.1.tar.gz"
  sha256 "8e85cfa57e8745715432df3116697c8f41cb24b5ec16d1d5acd25e0196d34303"
  revision 1

  bottle do
    sha256 "189959142af331c08649a31d1020082762538a235ad681768430252d0a7f6cbc" => :catalina
    sha256 "5ec568fa31ecdd6a558d800426b51246b1937ba118e2c48b46088387f10912aa" => :mojave
    sha256 "8cef2b27dc8edbaa90015a374a5c2f8ad82fbe124560d1fb277b1c9049fe517e" => :high_sierra
    sha256 "a9c6bbb24e9c0208d185fb118087c5618fa75ce4f001e3516295cbf7050ffc84" => :sierra
  end

  depends_on "ocaml"

  def install
    system "./configure", "-bindir", bin,
                          "-mandir", man,
                          "-sitelib", lib/"ocaml",
                          "-config", etc/"findlib.conf",
                          "-no-topfind"
    system "make", "all"
    system "make", "opt"
    inreplace "findlib.conf", prefix, HOMEBREW_PREFIX
    system "make", "install"

    # Avoid conflict with ocaml-num package
    rm_rf Dir[lib/"ocaml/num", lib/"ocaml/num-top"]
  end

  test do
    output = shell_output("#{bin}/ocamlfind query findlib")
    assert_equal "#{HOMEBREW_PREFIX}/lib/ocaml/findlib", output.chomp
  end
end
