class OcamlZarith < Formula
  desc "OCaml library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/Zarith"
  url "https://github.com/ocaml/Zarith/archive/refs/tags/release-1.14.tar.gz"
  sha256 "5db9dcbd939153942a08581fabd846d0f3f2b8c67fe68b855127e0472d4d1859"
  license "LGPL-2.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "23af6e559ef250564069891b91f78f06e7a7d8605d7899658ccb1ecb0884b6ac"
    sha256 cellar: :any,                 arm64_sequoia: "5a0ea1102ef6bbfb2cf31ec8ac97167dec44141f8994faaf69ed374b9bcd9241"
    sha256 cellar: :any,                 arm64_sonoma:  "d9bc12787eb89934cd84d2dde6399248922164b2a8b91176fb1cc40c3317f3e7"
    sha256 cellar: :any,                 arm64_ventura: "c8b7d5a319ce9fe9f18d430ab229bc3b14689388f6c81b880a1c5d13091d7414"
    sha256 cellar: :any,                 sonoma:        "36e07bdd7adf477fd3c6179ae4601c107f5d189ebe359cbc188acdaa0e8f5994"
    sha256 cellar: :any,                 ventura:       "08a7be2e0776792bc8adced1f4126d3ee03480895ee3133b149a0778176a68cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65d2d766f6f02619ea03042d3f4025d246d961209f23e72f1767a53d31da88b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7e4b58a4b9b745aa8270c606b350e3339474723b7130cb6683544f901b6c1d7"
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
