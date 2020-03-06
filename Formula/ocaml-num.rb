class OcamlNum < Formula
  desc "OCaml legacy Num library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/num"
  url "https://github.com/ocaml/num/archive/v1.3.tar.gz"
  sha256 "4f79c30e81ea9553c5b2c5b5b57bb19968ccad1e85256b3c446b5df58f33e94d"
  revision 1

  bottle do
    cellar :any
    sha256 "9767a628e3b326207c0800fbc84a6cb061d487d1de215073672c263674a4f37e" => :catalina
    sha256 "db56cb0607b94417b31c5e0479631ae0b2e712786140a204bc990d247ab843c3" => :mojave
    sha256 "6034f0ae346d64a651e72ea1da790f6d49869eb319bc447b53bde54cc93f1345" => :high_sierra
  end

  depends_on "ocaml-findlib" => :build
  depends_on "ocaml"

  def install
    ENV["OCAMLFIND_DESTDIR"] = lib/"ocaml"

    (lib/"ocaml").mkpath
    cp Formula["ocaml"].opt_lib/"ocaml/Makefile.config", lib/"ocaml"

    # install in #{lib}/ocaml not #{HOMEBREW_PREFIX}/lib/ocaml
    inreplace lib/"ocaml/Makefile.config", /^prefix=#{HOMEBREW_PREFIX}$/,
                                           "prefix=#{prefix}"

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
