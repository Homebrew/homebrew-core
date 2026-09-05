class Camlpdf < Formula
  desc "OCaml library for reading, writing and modifying PDF files"
  homepage "https://github.com/johnwhitington/camlpdf"
  url "https://github.com/johnwhitington/camlpdf/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "1885549dbb2e243b12d1b3752f443efc460400283ce318ec56fbe2f438a57ac8"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9030f89e39a806d39f5025e4936e8793770c1350dbfc6417c024d421b598c547"
    sha256 cellar: :any, arm64_sequoia: "982b6fb5956daba2cca9d43a0aa1abef64380b44b7e0bc7569f748ebe62e9b63"
    sha256 cellar: :any, arm64_sonoma:  "606903b74259c4df53e48ce6f46f5456eceb1d62b713d22f6cf850b626d20ef1"
    sha256 cellar: :any, arm64_linux:   "cb16f9b8feb7097664683d452b6308f543461d078e79926658af759fd739d854"
    sha256 cellar: :any, x86_64_linux:  "05b8080ddd834db231d480b6813674a7aa1469a3e146d4c215bdf056bf4ea63d"
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
