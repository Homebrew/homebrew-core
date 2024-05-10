class OcamlZarith < Formula
  desc "OCaml library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/Zarith"
  url "https://github.com/ocaml/Zarith/archive/refs/tags/release-1.13.tar.gz"
  sha256 "a5826d33fea0103ad6e66f92583d8e075fb77976de893ffdd73ada0409b3f83b"
  license "LGPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "932642604c05ad5bb0d69c83b846263480e871dd637a07b25dadd3c9819dd282"
    sha256 cellar: :any,                 arm64_ventura:  "ebcdae625f98d18e5165ddd32a50ba524cbc65608d0eadfb7ace4d7a2ed48ac4"
    sha256 cellar: :any,                 arm64_monterey: "94f18c52e35044939bc72ea6b318cc24b0a8dff9d0b224632fef51268a66f269"
    sha256 cellar: :any,                 sonoma:         "92762f6bd2138426c75811d46b6298aacf2a48796c1c74332369b52b69536634"
    sha256 cellar: :any,                 ventura:        "73bb4af9dd50aa6ca4c5be5b856e6d760279c14f3e8ec7950098b0718c405210"
    sha256 cellar: :any,                 monterey:       "ed57526ab3af9355aecd1990d5e142c825b135d10702465d23f125300bdd510c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c196a69f7ab0a5f9f03cdba4bf6be873cb49401a66c8d0fc84be5a846aa7662f"
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
