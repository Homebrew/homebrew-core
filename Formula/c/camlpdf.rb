class Camlpdf < Formula
  desc "OCaml library for reading, writing and modifying PDF files"
  homepage "https://github.com/johnwhitington/camlpdf"
  url "https://github.com/johnwhitington/camlpdf/archive/refs/tags/v2.9.tar.gz"
  sha256 "2bbc222eb6e1be4ef6ec2900a1bba1da652704ff1343e742726689e077d35a27"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2ae180c8730f1552db117b06df7f2abe50abd3eb2eb6d42e3136864c0dd92d31"
    sha256 cellar: :any,                 arm64_sequoia: "f8411747409bcb8ccc1a65bdbe81f6e07d96d98aa4af4120a76ee8781d932720"
    sha256 cellar: :any,                 arm64_sonoma:  "a74fbd0854dffb24c77f9e30bb61ae5513e1ea22f76b5f5e3d30b43fb21879e0"
    sha256 cellar: :any,                 sonoma:        "2919f746cc7d16eb9603f1e84543f7097672acd73964cc008c1af1006b380cc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc2ddfc666ce2a4e7977c2936ffbc4a8f949a828863c1254c2c1669bf525d5e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd11b6341f7102de7f52997ae11557fd8c3e95ce86f4ab741c39d839d6cd9b46"
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
