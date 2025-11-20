class Camlpdf < Formula
  desc "OCaml library for reading, writing and modifying PDF files"
  homepage "https://github.com/johnwhitington/camlpdf"
  url "https://github.com/johnwhitington/camlpdf/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "148994c70016f1b02fee1f5548ff7d36ba7d0a5716e03f95011160fcc495657b"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "11905e6ecf963dd498f8375ed474be764b50922044fc210d660376d250c49f98"
    sha256 cellar: :any,                 arm64_sequoia: "aefadfc9531ad433514d250c0ded7c4ff496682302e30157f253ed8e90ef2bfd"
    sha256 cellar: :any,                 arm64_sonoma:  "e84c0baa3eb14d7aea916545164eeaa878a2f8bd3c9cabb80f815121018dc1c9"
    sha256 cellar: :any,                 sonoma:        "a27ffe411ba9917e6805e1ee6f7f1a3df9258b1fa143cf48bd866d604d52a559"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8012e43591114b66a5a4e7457170dd2fc2d47b2b0957bce6e5ac730ef75677ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b238372051d39a3ccfbbbd3da90454e8977f2798df5f0f2315b827b97bdad6cb"
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
