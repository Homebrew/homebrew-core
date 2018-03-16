class OcamlNum < Formula
  desc "OCaml legacy Num library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/num"
  url "https://github.com/ocaml/num/archive/v1.1.tar.gz"
  sha256 "04ac85f6465b9b2bf99e814ddc798a25bcadb3cca2667b74c1af02b6356893f6"
  revision 2

  bottle do
    cellar :any
    sha256 "18368aa58ebeb352fade8f41b20f34d7817d37ebdbf5511fc253cd12a456b017" => :high_sierra
    sha256 "a59f29f535f567c689c92b65389e54f4d234b97a09a14e18004f0224db49fa58" => :sierra
    sha256 "c7eec65f527ecb97aeafe235aa3a5f21b5e2f3b5aad8391ea5e0575498fef0b9" => :el_capitan
  end

  depends_on "ocaml-findlib" => :build
  depends_on "ocaml"

  def install
    ENV["OCAMLFIND_DESTDIR"] = lib/"ocaml"

    (lib/"ocaml").mkpath
    cp Formula["ocaml"].opt_lib/"ocaml/Makefile.config", lib/"ocaml"

    # install in #{lib}/ocaml not #{HOMEBREW_PREFIX}/lib/ocaml
    inreplace lib/"ocaml/Makefile.config", /^PREFIX=#{HOMEBREW_PREFIX}$/,
                                           "PREFIX=#{prefix}"

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
