class OcamlZarith < Formula
  desc "OCaml library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/Zarith"
  url "https://github.com/ocaml/Zarith/archive/refs/tags/release-1.14.tar.gz"
  sha256 "5db9dcbd939153942a08581fabd846d0f3f2b8c67fe68b855127e0472d4d1859"
  license "LGPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ed8861f99b854e2e65c9d294e01f6b8ed0788abc19ebd3d4dc3ce7cfa34db096"
    sha256 cellar: :any,                 arm64_sonoma:  "1fef98a78a16f4a16510d4504391226ef04dae87230d44e8bc31e5b90909e8e7"
    sha256 cellar: :any,                 arm64_ventura: "c19075b8f0aa1e49811a07157d742fb7efd44cacc40bcf4f6a333b41c90b3414"
    sha256 cellar: :any,                 sonoma:        "3786c671d7fffb86a26e445c1da3f7144f612baf1830e53bbb45941df0b693c4"
    sha256 cellar: :any,                 ventura:       "1ca4591569e5651a8f6dcee7e567eefa1801bda9a30e1494ef1c059aa1da7f17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4757ac0829b2b289ca4400f4cf7a881a80d2e7a1d8f8bd8aef0eddab7d54b543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3ab7fd9e6eb25af8bf079f8b35985320694dbba6f44c4764ba123f129d9749b"
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
