class OcamlNum < Formula
  desc "OCaml legacy Num library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/num"
  url "https://github.com/ocaml/num/archive/v1.1.tar.gz"
  sha256 "04ac85f6465b9b2bf99e814ddc798a25bcadb3cca2667b74c1af02b6356893f6"
  revision 4

  bottle do
    cellar :any
    sha256 "787b74eaca216e9d2d3215c31eb5ca64a3b5761729bb562a5ce18e11e330897a" => :mojave
    sha256 "377c48b9d8974ec93b982451ffd9dae4c13b78f3d1ed8751a5e0361ac764d4d8" => :high_sierra
    sha256 "53e86f2602bc51ff1efa5ef4d7b73e1cb4552f268375b2d963ef96996859f0df" => :sierra
    sha256 "8b1751663a6a654443ed00dc489aabe149987e3def3fedab6697294e05b0b65d" => :el_capitan
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
