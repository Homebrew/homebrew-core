class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "http://download.camlcity.org/download/findlib-1.8.1.tar.gz"
  sha256 "8e85cfa57e8745715432df3116697c8f41cb24b5ec16d1d5acd25e0196d34303"
  revision 3

  bottle do
    sha256 "ba498040816b2b5b00ed84a96107119a99a52a0815b86ace5e5708f807be1ddb" => :catalina
    sha256 "b9af770177876ae3ffff6cca808a7ea72866a0bfe3b92a987878629fc42b3eff" => :mojave
    sha256 "a412ed75fa6bd7180846f2305eea5d2a4170bb41535c26fb047fbbd2b0adef8a" => :high_sierra
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
