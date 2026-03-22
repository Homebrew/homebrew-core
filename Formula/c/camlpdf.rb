class Camlpdf < Formula
  desc "OCaml library for reading, writing and modifying PDF files"
  homepage "https://github.com/johnwhitington/camlpdf"
  url "https://github.com/johnwhitington/camlpdf/archive/refs/tags/v2.9.tar.gz"
  sha256 "2bbc222eb6e1be4ef6ec2900a1bba1da652704ff1343e742726689e077d35a27"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8ea80573733f7a69935abe06422690752fce76edb6a27dac8bc1976b6fc3f0f0"
    sha256 cellar: :any,                 arm64_sequoia: "00918247784d02e38897e119f5853059b59a80020203f852ce952ada2af11187"
    sha256 cellar: :any,                 arm64_sonoma:  "f3b2796264a233801ddaec9906869105fda3aba8445c95414752803124c05554"
    sha256 cellar: :any,                 sonoma:        "3f8747e524240ad6c3e6778e585a668dd1ac0f5f423ac033a8d39f861d83648b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5d7a301e8215960741c3930db016f45dd3bceb130e7c7fe4b729d5aff760c39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7457d2eeec4b15bfb5815f51d4e3a707bbbc29837063f5bf97231b0a98bd845f"
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
