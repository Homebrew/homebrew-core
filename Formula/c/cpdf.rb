class Cpdf < Formula
  desc "PDF Command-line Tools"
  homepage "https://github.com/johnwhitington/cpdf-source"
  url "https://github.com/johnwhitington/cpdf-source/archive/refs/tags/v2.9.tar.gz"
  sha256 "944e2e578fc9653ccf09df4cf0c0b60beb3fb702ddd5b76640624d7324ae3cdb"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4decfc5e1b18bf1cc8d7d3ae01308c08f9ccb89f681ba7b529e68f9a773e9e95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f0f7da1259f83e9a2ffd56ad5b893a83221a1a93cd338b70ef16eb175f3c4a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb2824a1b3ed8389a6b6b71c64a6786b108080eedfb218662d3365867a6cb660"
    sha256 cellar: :any_skip_relocation, sonoma:        "280d6ec4fe43c9889b7f7e4f5c7c8749eddec1e8886c4a190004020ca50a89c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4935bd4039c9e7c9ea54eaab59500fcd382d3cda01ba8f54909aeac271e90e2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f19a3b6a5a202f4d93511fb785dc4f462e2492b19cc70f4f45710d9f8e458b5d"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "camlpdf"
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

    bin.install "cpdf"
  end

  test do
    system bin/"cpdf", "-create-pdf", "-o", "out.pdf"
    assert_match version.to_s, shell_output(bin/"cpdf")
    assert_path_exists testpath/"out.pdf"
  end
end
