class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "http://download.camlcity.org/download/findlib-1.9.1.tar.gz"
  sha256 "2b42b8bd54488d64c4bf3cb7054b4b37bd30c1dc12bd431ea1e4d7ad8a980fe2"
  license "MIT"
  revision 1

  livecheck do
    url "http://download.camlcity.org/download/"
    regex(/href=.*?findlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "d7eb98250b548a35bcc8479b6d1126adfc4c30c9044bb78edf74b245dcae86fa"
    sha256 big_sur:       "15951d7142caf7b8287312c22761faaba781c2e5bd12a02c1af1679520a0db29"
    sha256 catalina:      "5d0337fda51924cbad0f68c6b39a2ba7dc082a29b34121de6de80f13d6421311"
    sha256 mojave:        "78bcc5df2366f5046b90384e6bde8f81e038041354a3daae361c09a6cad29228"
  end

  depends_on "ocaml"

  uses_from_macos "m4" => :build

  def install
    # Specify HOMEBREW_PREFIX here so those are the values baked into the compile,
    # rather than the Cellar
    system "./configure", "-bindir", bin,
                          "-mandir", man,
                          "-sitelib", HOMEBREW_PREFIX/"lib/ocaml",
                          "-config", etc/"findlib.conf",
                          "-no-camlp4"

    system "make", "all"
    system "make", "opt"

    # Override the above paths for the install step only
    system "make", "install", "OCAML_SITELIB=#{lib}/ocaml",
                              "OCAML_CORE_STDLIB=#{lib}/ocaml"

    # Avoid conflict with ocaml-num package
    rm_rf Dir[lib/"ocaml/num", lib/"ocaml/num-top"]
  end

  test do
    output = shell_output("#{bin}/ocamlfind query findlib")
    assert_equal "#{HOMEBREW_PREFIX}/lib/ocaml/findlib", output.chomp
  end
end
