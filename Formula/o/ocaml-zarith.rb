class OcamlZarith < Formula
  desc "OCaml library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/Zarith"
  url "https://github.com/ocaml/Zarith/archive/refs/tags/release-1.13.tar.gz"
  sha256 "a5826d33fea0103ad6e66f92583d8e075fb77976de893ffdd73ada0409b3f83b"
  license "LGPL-2.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "85b400fa6861f589bedb6f40c99848fda05ead5c4688d026782b594faa61f85b"
    sha256 cellar: :any,                 arm64_ventura:  "8ff062fbfca3ad3c65e752c03f7d4d00cbe1825a8179b3d6b2ae8a4aff60e218"
    sha256 cellar: :any,                 arm64_monterey: "86fd9c681ff691a68efa6832b4942c5b7ab202c6940655f66c19a53641808573"
    sha256 cellar: :any,                 sonoma:         "5347a67f893e51944fc7d781abcca6b42af49aa86d9f590e816bbabf1fe752d5"
    sha256 cellar: :any,                 ventura:        "7c3f79fa6b1a362ef4fca2ce9765820cdd09fb9d62da6185fd2ed7154eb3cfed"
    sha256 cellar: :any,                 monterey:       "de7eaedd674f2af979fd9485c37efeba9f92d546800bcaae7d5dd80e31c9371a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cf499a4828612b8ee118b3cb9e9e38b7a2f2c79480833a729a869201fe87737"
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
