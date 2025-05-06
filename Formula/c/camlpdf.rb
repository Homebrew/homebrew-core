class Camlpdf < Formula
  desc "OCaml library for reading, writing and modifying PDF files"
  homepage "https://github.com/johnwhitington/camlpdf"
  url "https://github.com/johnwhitington/camlpdf/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "148994c70016f1b02fee1f5548ff7d36ba7d0a5716e03f95011160fcc495657b"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "34f2db85bff44fd2a7b00704e099a76106d85431dcb8f122a74ad530e585407d"
    sha256 cellar: :any,                 arm64_sonoma:  "22e65fe30f42615d8711c07c4d9df5fe61942f4e315575725d274d9572b13bd3"
    sha256 cellar: :any,                 arm64_ventura: "5b4993442c060aba6405e5518b9246e72d4c6369f31dc5632d58398fa9456c44"
    sha256 cellar: :any,                 sonoma:        "804e849272f9ed7d58a318a199bae0a46169b46366ed87c136d7a6142b83bad0"
    sha256 cellar: :any,                 ventura:       "0f9d1b46f0389a342fa7305efe0393526860c2e6704537ae5d66e4456619adbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ce0aeb1507e9dfc7d1061644db37159269e094c72306989f01658744e8dd04a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae56e872f83e5c2e5087e75108baa31c90171fe2de3c14495b6fb41d6dd7feb8"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "ocaml"

  def install
    # For OCamlmakefile
    ENV.deparallelize

    # Work around for https://github.com/Homebrew/homebrew-test-bot/issues/805
    if ENV["HOMEBREW_GITHUB_ACTIONS"] && !(Formula["ocaml-findlib"].etc/"findlib.conf").exist?
      ENV["OCAMLFIND_CONF"] = Formula["ocaml-findlib"].opt_libexec/"findlib.conf"
    end

    ENV["OCAMLFIND_DESTDIR"] = lib/"ocaml"

    (lib/"ocaml").mkpath
    cp Formula["ocaml"].opt_lib/"ocaml/Makefile.config", lib/"ocaml"

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
    system Formula["ocaml"].opt_bin/"ocamlopt", "-I", lib/"ocaml/camlpdf", "-I",
           Formula["ocaml"].opt_lib/"ocaml", "-o", "test", "camlpdf.cmxa",
           "test.ml"
    assert_match "camlpdf", shell_output("./test")
  end
end
