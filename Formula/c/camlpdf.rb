class Camlpdf < Formula
  desc "OCaml library for reading, writing and modifying PDF files"
  homepage "https://github.com/johnwhitington/camlpdf"
  url "https://github.com/johnwhitington/camlpdf/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "08e13a341362fb586a8bb02daf85fc1ef62250b63e6b58812b9c361e3d1c9951"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d5c2dff8b75cf896f900f0c9052826782b6b16113b602c35273db88e659bf3c1"
    sha256 cellar: :any, arm64_sequoia: "21174a96c69b78a5edde527bfe65547ff301155a061850451727c28a4996ff16"
    sha256 cellar: :any, arm64_sonoma:  "ece374aa8b3a4d4936bdae807c94cf2f84bd7fda8d87ee02ff5ecd6b01870fdb"
    sha256 cellar: :any, sonoma:        "d84ab1214ef2c1d91e3320e349c05a8637742696a74346b560b9611d688404d8"
    sha256 cellar: :any, arm64_linux:   "c42af637faafab4b67e0ed457cec6106bb1725d3f526938b361111df28652641"
    sha256 cellar: :any, x86_64_linux:  "4e8c919e3df23529c85d670e018b57078ea69c15b75f3dea50c2dd0a1d316380"
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
