class OcamlNum < Formula
  desc "OCaml legacy Num library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/num"
  url "https://github.com/ocaml/num/archive/v1.4.tar.gz"
  sha256 "015088b68e717b04c07997920e33c53219711dfaf36d1196d02313f48ea00f24"
  license "LGPL-2.1"

  bottle do
    cellar :any
    sha256 "11159571ab66414961a6718bd051734adedecf9f7f6967eb7501305bd63657ab" => :big_sur
    sha256 "545f99711189baa3a903adc55ac696aa75dd954298fd6135edf11d2a4047dc3b" => :catalina
    sha256 "26022dbe85f98f4f051dd33e1743ac7e631320a4a31583b825dcdfd69731fd5b" => :mojave
    sha256 "50101019c768a94a15f1b387464b2280f7c8e0db8e1e1349bca070a9fb4506ba" => :high_sierra
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
