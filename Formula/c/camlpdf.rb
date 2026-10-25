class Camlpdf < Formula
  desc "OCaml library for reading, writing and modifying PDF files"
  homepage "https://github.com/johnwhitington/camlpdf"
  url "https://github.com/johnwhitington/camlpdf/archive/refs/tags/v2.9.3.tar.gz"
  sha256 "b90f79dacd9cfbae140581c8548b3d2e5cdda7176ce62d2724e616f94750f6cb"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7bef7996de845d20c79d55157a68a938d7d62c41d3a3e68e4f67708fa28ab6e2"
    sha256 cellar: :any, arm64_tahoe:       "ab2bf8eeda38ac239d793929b97802fd5bc51f4f90a51b05a564e2dc2e63e90b"
    sha256 cellar: :any, arm64_sequoia:     "7ac7f77695a9cdc9f0c2c7bbc35d8cad1683548d03eae54a08638ae3f879c0ba"
    sha256 cellar: :any, arm64_linux:       "33f13f35e25769b5ebddc43b619c7c4e0d9c23551a6dc6f9dab04211db32f2e5"
    sha256 cellar: :any, x86_64_linux:      "6f8276c2abdae74385424500fe5bc67efdf3b36795564b9e0382fed31f3087bb"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "ocaml"

  def install
    # For OCamlmakefile
    ENV.deparallelize

    # Work around for https://github.com/Homebrew/homebrew-test-bot/issues/805
    if ENV["HOMEBREW_GITHUB_ACTIONS"] && !(Formula["ocaml-findlib"].etc/"findlib.conf").exist?
      ENV["OCAMLFIND_CONF"] = formula_opt_libexec("ocaml-findlib")/"findlib.conf"
    end

    ENV["OCAMLFIND_DESTDIR"] = lib/"ocaml"

    (lib/"ocaml").mkpath
    cp formula_opt_lib("ocaml")/"ocaml/Makefile.config", lib/"ocaml"

    # install in #{lib}/ocaml not #{HOMEBREW_PREFIX}/lib/ocaml
    inreplace lib/"ocaml/Makefile.config" do |s|
      s.change_make_var! "prefix", prefix
    end

    system "make"
    (lib/"ocaml/stublibs").mkpath # `make install` assumes this directory exists
    system "make", "install", "STDLIBDIR=#{lib}/ocaml"

    rm lib/"ocaml/Makefile.config" # avoid conflict with ocaml
  end

  test do
    (testpath/"test.ml").write "Pdfutil.flprint \"camlpdf\""
    system formula_opt_bin("ocaml")/"ocamlopt", "-I", lib/"ocaml/camlpdf", "-I",
           formula_opt_lib("ocaml")/"ocaml", "-o", "test", "camlpdf.cmxa",
           "test.ml"
    assert_match "camlpdf", shell_output("./test")
  end
end
