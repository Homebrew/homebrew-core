class Camlpdf < Formula
  desc "OCaml library for reading, writing and modifying PDF files"
  homepage "https://github.com/johnwhitington/camlpdf"
  url "https://github.com/johnwhitington/camlpdf/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "148994c70016f1b02fee1f5548ff7d36ba7d0a5716e03f95011160fcc495657b"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "054523536942144aac397e1cfe790c696e490cef0a141dc007507cc44713a12a"
    sha256 cellar: :any,                 arm64_sequoia: "77f6a233df39070c851ee537db4b8bf91a7129b24eff67836cb333048d31277d"
    sha256 cellar: :any,                 arm64_sonoma:  "5926cd4ac90bf03933efccbda9b160da172534394aab20b867bd6e36dbb6cf83"
    sha256 cellar: :any,                 arm64_ventura: "39b8857baa16288fe2d5e3c578e6d0f2cd76a08f758cbb076ba5cba0d4cb10aa"
    sha256 cellar: :any,                 sonoma:        "510044b9ccacc708db2f2afe0dcc4ff5b3b40531f1bd5ee9ca1774fb60fb1557"
    sha256 cellar: :any,                 ventura:       "6635e7d007d6ba376988c8fcebe1c91a46139cbdaa0129545c3c528dbf08d842"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0dbea7a2dcf1a9848cb38eb24735880a20657713a0b59e9108d90c260e89003"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd51104090ae31d9d09591a89cf67718c2a107fd3974d97f06d0eccdc9ebd969"
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
