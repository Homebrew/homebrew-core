class OcamlNum < Formula
  desc "OCaml legacy Num library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/num"
  url "https://github.com/ocaml/num/archive/refs/tags/v1.4.tar.gz"
  sha256 "015088b68e717b04c07997920e33c53219711dfaf36d1196d02313f48ea00f24"
  license "LGPL-2.1"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4f55c47b06e334594da2c757e4c2dc82affc09672796172648185d8cdd8aaf31"
    sha256 cellar: :any,                 arm64_ventura:  "6522c296cac6b00245d89993e69ce05f529ba348cac150d33ab4cdb1e2cd9ce4"
    sha256 cellar: :any,                 arm64_monterey: "2adae92ec142eb1aefa496b08ddc3632b3b0a57e3d44c5f561465039f6d29b43"
    sha256 cellar: :any,                 sonoma:         "c59ad39d07225b342bd493c1d4531082e2798f160bc33663487981a6b265bb5b"
    sha256 cellar: :any,                 ventura:        "9fa9786f28eb04e77dd3960bdf8e4674714b95d436183e9638cc646be0a19c8c"
    sha256 cellar: :any,                 monterey:       "137b0fb7b9dbc961eee2a9449e4fcdf6a7e631cb77be7e8aa5448d366ef001e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "320ed8b1cb2b9e3018fe2c524a8781936b62b55ec2de65e732c0a1c08117936f"
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
