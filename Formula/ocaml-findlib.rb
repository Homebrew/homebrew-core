class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "http://download.camlcity.org/download/findlib-1.8.1.tar.gz"
  sha256 "8e85cfa57e8745715432df3116697c8f41cb24b5ec16d1d5acd25e0196d34303"
  revision 1

  bottle do
    sha256 "b59570c74713f43320a8990e0dcc0943952b21d5aa838efc9adcfe13c3ec505c" => :mojave
    sha256 "5a7461260e9ec4d164c85524d6103d95c11a4f94d55485acce6ba93fb315c436" => :high_sierra
    sha256 "adf4b6c159dc2f73504eb613c2080fc9fcc44c6e6f59e948edbc5db0a9905bf9" => :sierra
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
