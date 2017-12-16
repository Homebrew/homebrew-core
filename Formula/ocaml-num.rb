class OcamlNum < Formula
  desc "OCaml legacy Num library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/num"
  url "https://github.com/ocaml/num/archive/v1.1.tar.gz"
  sha256 "04ac85f6465b9b2bf99e814ddc798a25bcadb3cca2667b74c1af02b6356893f6"
  revision 1

  bottle do
    cellar :any
    sha256 "91fe9987b76ad40318368ab127bbdb82c74c176ccba723a3fe5ebd3a13fb5523" => :high_sierra
    sha256 "d73e9d1b6601fcdbcede7c74cc0326897ebcbd566860f6ae796be0f215d6ce97" => :sierra
    sha256 "c114181c1020d48f475ac78a78c29cc7a9c24baa68d8527170708d0f54439425" => :el_capitan
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
