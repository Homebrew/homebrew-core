class OcamlNum < Formula
  desc "OCaml legacy Num library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/num"
  url "https://github.com/ocaml/num/archive/v1.1.tar.gz"
  sha256 "04ac85f6465b9b2bf99e814ddc798a25bcadb3cca2667b74c1af02b6356893f6"
  revision 1

  bottle do
    cellar :any
    sha256 "a4f50d0069738993966f9290cc073d92d63d702c2013bc3e6bcf8d1d7d62a32a" => :high_sierra
    sha256 "fa2a6a86b8f09c04d5631416e15f7a8023fdbe3a1139a37be60cfc69a826cd4f" => :sierra
    sha256 "5056cd652b799d13409a57bb824d1d10ed28470e16d61bdb99213707c987d3d5" => :el_capitan
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
