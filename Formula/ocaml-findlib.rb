class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "http://download.camlcity.org/download/findlib-1.8.1.tar.gz"
  sha256 "8e85cfa57e8745715432df3116697c8f41cb24b5ec16d1d5acd25e0196d34303"
  revision 3

  bottle do
    sha256 "be41efac9afcaa4d670c7069df0431c5f4168b0b4f100267972bcf2b9363f8c1" => :catalina
    sha256 "be5bcf7112b6aad4b3a6a09f53fe301cc2981f1c454ec8f906fa8b4031f349a7" => :mojave
    sha256 "ec94556f0d00f6b3af413b6fc269e92b130c453bd59eee81338ef2ee9beab373" => :high_sierra
  end

  depends_on "ocaml"

  uses_from_macos "m4" => :build

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
