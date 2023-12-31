class OcamlNum < Formula
  desc "OCaml legacy Num library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/num"
  url "https://github.com/ocaml/num/archive/refs/tags/v1.5.tar.gz"
  sha256 "7ae07c8f5601e2dfc5008a62dcaf2719912ae596a19365c5d7bdf2230515959a"
  license "LGPL-2.1"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6a837fdd87b83bdb4db4602fc9942dad50624c7d99481f41b99716bf592aee85"
    sha256 cellar: :any,                 arm64_ventura:  "231cfed2d688c19e41a1ae0c82905ccb3959cc6fbc86d2217ca9deb6a8288266"
    sha256 cellar: :any,                 arm64_monterey: "4d375fd5288c5f44f4ff65e5c85eb1e92b887af71db96b2e3f63a80399993a0d"
    sha256 cellar: :any,                 sonoma:         "f2b874ac0a07256fa90b68eadf30afa7f47fd93ce401ba2427811d9d8260d5e3"
    sha256 cellar: :any,                 ventura:        "9ee4141f058d0fe4d54ebb82fa0e9775cc7710ee54beec33ffea4167e92b4f3e"
    sha256 cellar: :any,                 monterey:       "12dfa8ad705078f598817b0da7318ecd976c96d711c10fb77cce6c280c12bf77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e0e5e92a00aefb0ee4682437417fd5ee86e02671738c9b476820573f13f44e7"
  end

  depends_on "ocaml-findlib" => :build
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

    system "make"
    (lib/"ocaml/stublibs").mkpath # `make install` assumes this directory exists
    system "make", "install", "STDLIBDIR=#{lib}/ocaml"

    pkgshare.install "test"

    rm lib/"ocaml/Makefile.config" # avoid conflict with ocaml
  end

  test do
    cp_r pkgshare/"test/.", "."
    system Formula["ocaml"].opt_bin/"ocamlopt", "-I", lib/"ocaml", "-I",
           Formula["ocaml"].opt_lib/"ocaml", "-o", "test", "nums.cmxa",
           "test.ml", "test_nats.ml", "test_big_ints.ml", "test_ratios.ml",
           "test_nums.ml", "test_io.ml", "end_test.ml"
    assert_match "1... 2... 3", shell_output("./test")
  end
end
