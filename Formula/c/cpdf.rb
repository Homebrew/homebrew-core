class Cpdf < Formula
  desc "PDF Command-line Tools"
  homepage "https://github.com/johnwhitington/cpdf-source"
  url "https://github.com/johnwhitington/cpdf-source/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "bfcabf3a1e1a55840df55229afc992873b311ae50bd5a9b4135c9aef7ef91f0e"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d4634781fea457538c77518fe8809b7ae4b4987d738d1bd22b3c10c2199fc870"
    sha256 cellar: :any, arm64_sequoia: "cd5a463bd9dcf7f9ddb35dd6600da2ae7a3da152188ecccb4abb738d0d7f965c"
    sha256 cellar: :any, arm64_sonoma:  "6f6f8150f84254aabfb6f5a85fec2366eeac29c0e1d3581bbae5c1f73c07d572"
    sha256 cellar: :any, arm64_linux:   "45346ff1bfcb7841585d9b0384299a5b7dbbefd24119a53bb3fa213946498fe9"
    sha256 cellar: :any, x86_64_linux:  "be62ced6da951066eba70c2f678959b5fd58deff01b40f1ac312bbc8b743393f"
  end

  depends_on "camlpdf" => :build
  depends_on "ocaml" => :build
  depends_on "ocaml-findlib" => :build

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

    bin.install "cpdf"
  end

  test do
    system bin/"cpdf", "-create-pdf", "-o", "out.pdf"
    assert_match version.to_s, shell_output(bin/"cpdf")
    assert_path_exists testpath/"out.pdf"
  end
end
