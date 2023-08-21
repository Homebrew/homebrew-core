class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "http://download.camlcity.org/download/findlib-1.9.6.tar.gz"
  sha256 "2df996279ae16b606db5ff5879f93dbfade0898db9f1a3e82f7f845faa2930a2"
  license "MIT"

  livecheck do
    url "http://download.camlcity.org/download/"
    regex(/href=.*?findlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "bac75b12905f7138e93455ef3c4599fd417448dccafec8cbf5cc63b7192b63c7"
    sha256 arm64_monterey: "3b7dc9a49293c982c8b8fbb4bd3a979b652d9bf48b6ae6a915fe734960acb2d3"
    sha256 arm64_big_sur:  "259a336b537993add90ebef09bc6473dfa39426ee80292d443307f36e77e8ac4"
    sha256 ventura:        "c9731166502de936c4897ce2f9c50b0432ac81f53dd904569ef406a4ac7bcbae"
    sha256 monterey:       "716c17abb924c7958ebad686f456cd3c19842ba334875ae0a91f1392df756815"
    sha256 big_sur:        "d6e7046fbe14735edb44ce83654736a476357344009fe7fd497416ade6374c47"
    sha256 catalina:       "ef1c177401fad930e6912ae5103326dc673913e0ec16d1bd730bcc6ba5a43cf8"
    sha256 x86_64_linux:   "c319106538e9f3e0faecd3900c1ebd105ad9b39645e0952ed5cd14de9b8ef2e4"
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
