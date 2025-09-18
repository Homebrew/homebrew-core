class Cpdf < Formula
  desc "PDF Command-line Tools"
  homepage "https://github.com/johnwhitington/cpdf-source"
  url "https://github.com/johnwhitington/cpdf-source/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "bdd7caf1e5e55e65e4ece96eeeb3e5894c195ca5a9a274ddc27ac50a321d5c75"
  license "AGPL-3.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3a25d6ed520e5a2a997da0992156246005d2449a26fb7a96132520764c0ea18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e97a2d112914e6eac5e522a8663deb1771ef04e8296fdf34db39558a0dadca23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b36ddb34c391665d5337de6b63118487263285b5917528d4c52847510af548d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91772514307f75224ff0558fcc18999cf76cb7603851a5f94258e272bfb3a5a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e63b9e7612e18c9c577aa502c7be73ee534e46650c51911372ab8ec032e0b8c"
    sha256 cellar: :any_skip_relocation, ventura:       "ede4654c045aea5a2aff498c6bd77f3ff8d284df6c7dfc5c5ed0bd491c96d188"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b190429b65b7f9dec51957e6f876901572d403a056db2bb37939b64b50d2df0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bcaa237cb5ad235f05cab8067bac39d4a57aa49195462872f409195a744b4aa"
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
