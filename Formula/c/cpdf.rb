class Cpdf < Formula
  desc "PDF Command-line Tools"
  homepage "https://github.com/johnwhitington/cpdf-source"
  url "https://github.com/johnwhitington/cpdf-source/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "8f96f92b2b19b42a6ee3aeb5986e7223a9fcfc8c65e534b6b45cb9525251ca80"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1b8cdfed347cffdda29e39d92ecfd2935039aae8805bcdf507803f94b612761c"
    sha256 cellar: :any, arm64_sequoia: "3c5893a511e27e867415614feadca123977dce77d4e575d39585c532fd8eff9f"
    sha256 cellar: :any, arm64_sonoma:  "a2f6bc4effa8b40a7fe1f40322d5588e02b55f9fa1cef5882e4706404070841e"
    sha256 cellar: :any, sonoma:        "1aee06b3bcae05d639346ef36ef6f5378228fceef3d779c7dd12920660217bd9"
    sha256 cellar: :any, arm64_linux:   "86eeb1a33f5bcbc8cf66727fd8c7c9bdbd01c67cb234778dffe9c24e7321d2f0"
    sha256 cellar: :any, x86_64_linux:  "9c37e3f802f43f1c11e86cb534c5361b4fe5c2b50cbd9f58c6573c826e20bd4d"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "camlpdf"
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

    bin.install "cpdf"
  end

  test do
    system bin/"cpdf", "-create-pdf", "-o", "out.pdf"
    assert_match version.to_s, shell_output(bin/"cpdf")
    assert_path_exists testpath/"out.pdf"
  end
end
