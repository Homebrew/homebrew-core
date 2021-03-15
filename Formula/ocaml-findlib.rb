class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "http://download.camlcity.org/download/findlib-1.9.tar.gz"
  sha256 "87149dc72cd33ebe6580e250fd2e369c01822a2ef882cd5a365d8e92b2bd9996"
  license "MIT"

  livecheck do
    url "http://download.camlcity.org/download/"
    regex(/href=.*?findlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "5f55cdc49e933d7f2ee47ef4ca2f2ad5969b72ecdfea438184cbbf8b5505bc81"
    sha256 big_sur:       "dc52beb2a668d316a30028f1183a8759b546ca34f7002e4040e1ff4e2b1f27d9"
    sha256 catalina:      "4dc5bb648554bfb3aba9dc068c826f4bf95df811fef3c2a62ba1d0a91436751d"
    sha256 mojave:        "f0321b2ae9ecb4119290845a0b18d32966e738155626098498b1409ca7db5188"
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
