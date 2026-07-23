class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "https://github.com/ocaml/ocamlfind/archive/refs/tags/findlib-1.9.8.tar.gz"
  sha256 "d6899935ccabf67f067a9af3f3f88d94e310075d13c648fa03ff498769ce039d"
  license "MIT"
  revision 4

  livecheck do
    url "https://opam.ocaml.org/packages/ocamlfind/"
    regex(/href=.*?findlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256               arm64_tahoe:   "9f0f9c46ea933433d03c7a579a25b1ecfbef128abc01bffd5e10861c03712405"
    sha256               arm64_sequoia: "f7a6a3d6cd034e2d01c267763e332356895cec34098cdb4bcf17627b34ebc53f"
    sha256               arm64_sonoma:  "00b7e1d07f8850abb0294ed39375dd287571f79f4efc7672baa88066e87a2684"
    sha256 cellar: :any, sonoma:        "d311d75665995914aa4c149fe6a1e9b1c20780097c5b9799cc3716ccd68ad914"
    sha256               arm64_linux:   "06d19ac00cd1f1f2207fa7f6fd74af28a94be2d7e822d61f16699ac1696c1d30"
    sha256               x86_64_linux:  "7b9dd899788d362e7e5e252d2c9bf2218c416d631c5f6fb9de83de51bc9fd088"
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
    rm_r(Dir[lib/"ocaml/num", lib/"ocaml/num-top"])

    # Save extra findlib.conf to work around https://github.com/Homebrew/homebrew-test-bot/issues/805
    libexec.mkpath
    cp etc/"findlib.conf", libexec/"findlib.conf"
  end

  test do
    output = shell_output("#{bin}/ocamlfind query findlib")
    assert_equal "#{HOMEBREW_PREFIX}/lib/ocaml/findlib", output.chomp

    # Check if we need to rebuild ocaml-findlib to be used as a library
    (testpath/"test.ml").write <<~OCAML
      open Findlib;;
      Findlib.init();
    OCAML
    system formula_opt_bin("ocaml")/"ocamlopt", "-I", lib/"ocaml/findlib", "-o", "test", "findlib.cmxa", "test.ml"
    system "./test"
  end
end
