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
    sha256 arm64_monterey: "d6eda73dbf7b59eea17cb638182c8145b523989c983ea22e369335029410409e"
    sha256 arm64_big_sur:  "0adb0140d0c7ab695aa19901a7cf2ea4ee5829517e25baf199b4b6dbf24d6236"
    sha256 monterey:       "73b045d1491ae15b66da7f7716aed4deb6885f27f6f858ef11b00e642793a3c4"
    sha256 big_sur:        "f0ce310996e8e71a8480e75f869b9b4f4071f99eb5d773b7c331c8ca71bd19d3"
    sha256 catalina:       "d4ee36411ddca117e7fd047e094611d500f9bfeb5684864f5b04ad68c9c7e3ca"
    sha256 x86_64_linux:   "0a8fcd1e7d971717acb469a477cef1622650ca382052cce3609ac24e6d846668"
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
