class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "http://download.camlcity.org/download/findlib-1.8.1.tar.gz"
  sha256 "8e85cfa57e8745715432df3116697c8f41cb24b5ec16d1d5acd25e0196d34303"
  revision 1

  bottle do
    rebuild 1
    sha256 "2a3c79c6edf1956bf90c7884e6ee6cdf09ccc55ca8786c5c788b66e158ad5e70" => :catalina
    sha256 "cf2039ac10218c3ba103ae2755493607643a60d0b56c4328ce064e8c72d7f86d" => :mojave
    sha256 "edd8dbf4b6366bd6c046a34747c8926bbc6e91b1b38fd50efaf3d13de9134ecb" => :high_sierra
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
