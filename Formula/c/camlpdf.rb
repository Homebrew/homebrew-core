class Camlpdf < Formula
  desc "OCaml library for reading, writing and modifying PDF files"
  homepage "https://github.com/johnwhitington/camlpdf"
  url "https://github.com/johnwhitington/camlpdf/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "08e13a341362fb586a8bb02daf85fc1ef62250b63e6b58812b9c361e3d1c9951"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aa896a33737039b1138992fbe9d116ed0408771bbd6c8607bd5179f608de775e"
    sha256 cellar: :any,                 arm64_sequoia: "3476bf243e8391a6b136c19231a3d464378579d170e67f285bc91b253bd80eb1"
    sha256 cellar: :any,                 arm64_sonoma:  "3121e1630692a9cfad61ee9a2d9ed87a54f0fa83c5aacb5d9ad197166e5136ba"
    sha256 cellar: :any,                 sonoma:        "fb78b3997a770f02b4bec027d2b96fbe189fee5dfeebeb3934a5c6300d83549a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68e83f2c6a67bc4a48c8e7cca718aa05a63ae5a194e16c277a82804902dc6901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02297b0672b4fe3015cec7916b5ee1d5f67d94d904fdb6cb6753a7796d6a9748"
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
