class OcamlNum < Formula
  desc "OCaml legacy Num library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/num"
  url "https://github.com/ocaml/num/archive/v1.4.tar.gz"
  sha256 "015088b68e717b04c07997920e33c53219711dfaf36d1196d02313f48ea00f24"
  license "LGPL-2.1"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "fc2e933047de0f32e0802f2233202c076098e1c18669a2bfb266ae1ddf357e74"
    sha256 cellar: :any, big_sur:       "ec4da1895770f1bb0e657493bb65737632927c5888bf3b5f203277a6c47495df"
    sha256 cellar: :any, catalina:      "b0c05329d5a13be31143dffb145210d52644775185d3545490519aac7ec72a90"
    sha256 cellar: :any, mojave:        "d8a6415aab44a93f0c1985f2a4ef0bbc8f69f8ec1dbf69965a4c13f9d7ebe075"
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
