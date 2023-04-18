class OcamlNum < Formula
  desc "OCaml legacy Num library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/num"
  url "https://github.com/ocaml/num/archive/v1.4.tar.gz"
  sha256 "015088b68e717b04c07997920e33c53219711dfaf36d1196d02313f48ea00f24"
  license "LGPL-2.1"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1376f678d4ee8141b6ce772985df8a1397f3e4831b02160a8057e3b195b26f90"
    sha256 cellar: :any,                 arm64_monterey: "24a7c2eb700a74089c1fbdb5395473c4afa7f90e86372b556c7b48b4caab23fc"
    sha256 cellar: :any,                 arm64_big_sur:  "e14151e4a14faa9a43774d4682930994110f9d654d533091b48a35ed95bfe8eb"
    sha256 cellar: :any,                 ventura:        "6fd4ac3c6c935c55379ff625b59501cda84097a366fd762d99d6cdc1d66d5f91"
    sha256 cellar: :any,                 monterey:       "36835ca0d89b6ccf37c1dbb3596b2e1ba688148cac83d6ddda1d2bdf5ddb2a00"
    sha256 cellar: :any,                 big_sur:        "0d247f113c3d0135e09a2b0a12a9299217600477083b089c5731bcf2b2245c36"
    sha256 cellar: :any,                 catalina:       "5dbcc04ba33b58d14b77ae7382345b9abd913ce342c20c330c4cf15c936b24f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a1b1383e37f8f367f8f5c6c44a86f9e76c17080d3aa0465bfcff9328da88d68"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "ocaml"

  def install
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
