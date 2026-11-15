class Camlpdf < Formula
  desc "OCaml library for reading, writing and modifying PDF files"
  homepage "https://github.com/johnwhitington/camlpdf"
  url "https://github.com/johnwhitington/camlpdf/archive/refs/tags/v2.9.3.tar.gz"
  sha256 "b90f79dacd9cfbae140581c8548b3d2e5cdda7176ce62d2724e616f94750f6cb"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5a7970101f0490d13e3c1197fc1669049696fdb15ffb47144bc6437d60bb9e48"
    sha256 cellar: :any, arm64_tahoe:       "e832298768e57b63ae62b7d79cb16b5359fa6f40db8c48866e725bc459585001"
    sha256 cellar: :any, arm64_sequoia:     "dc4c98669d2ddc3301c3a44467e9dcb893cee12902200e9ea0a4f5d80ae6aa30"
    sha256 cellar: :any, arm64_linux:       "0d3946228128a1809c57ed84f42a74fe8835faeb084fa7f902fbc57fa5ecd772"
    sha256 cellar: :any, x86_64_linux:      "180e12c4ade3578ba658506e5774a045ac26abf4058b49fa1efd563a563a9bf5"
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
