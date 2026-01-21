class OcamlZarith < Formula
  desc "OCaml library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/Zarith"
  url "https://github.com/ocaml/Zarith/archive/refs/tags/release-1.14.tar.gz"
  sha256 "5db9dcbd939153942a08581fabd846d0f3f2b8c67fe68b855127e0472d4d1859"
  license "LGPL-2.0-only"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f59725b44ef1aa8656404d833c812f2ff3d2a2bc539ef998fe5aa2baeb079f1c"
    sha256 cellar: :any,                 arm64_sequoia: "d023c1e616b868d7fb2a773eeb426aab87d0ad4cd102df7c4eccb5cd0c3e959e"
    sha256 cellar: :any,                 arm64_sonoma:  "59b4a24ead8319c8837252ca0702265c46e3820aa5629b9a940412edd50ab144"
    sha256 cellar: :any,                 sonoma:        "69a2fafdd5ad8ecdd81ba9e812289b760feeffd275df0aa5b2bfd346272ad87c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fbd3299e51a580a8b64f03f0bf132f426a3d49d07c7cb03e4f3b2e7220520db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dee59068932c13b018ec393239f0d5c9691924998a76ea2d031da8eff1fb482e"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "gmp"
  depends_on "ocaml"

  def install
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

    ENV.deparallelize
    system "./configure"
    system "make"
    (lib/"ocaml/stublibs").mkpath # `make install` assumes this directory exists
    system "make", "install", "STDLIBDIR=#{lib}/ocaml"

    pkgshare.install "tests"

    rm lib/"ocaml/Makefile.config" # avoid conflict with ocaml
  end

  test do
    cp_r pkgshare/"tests/.", "."
    system Formula["ocaml"].opt_bin/"ocamlopt", "-I", lib/"ocaml/zarith",
           "-ccopt", "-L#{lib}/ocaml -L#{Formula["gmp"].opt_lib}",
           "zarith.cmxa", "-o", "zq.exe", "zq.ml"
    expected = File.read("zq.output64", mode: "rb")
    assert_equal expected, shell_output("./zq.exe")
  end
end
