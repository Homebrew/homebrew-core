class OcamlNum < Formula
  desc "OCaml legacy Num library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/num"
  url "https://github.com/ocaml/num/archive/v1.3.tar.gz"
  sha256 "4f79c30e81ea9553c5b2c5b5b57bb19968ccad1e85256b3c446b5df58f33e94d"
  revision 1

  bottle do
    cellar :any
    sha256 "7890616190d8d7071d8c3cf2ea494885a115fc3b2d4058cb4be81132622e6cf2" => :catalina
    sha256 "e6feb685e5bc9486eee9c9a3a8f8712a6df05bc6564c518b0549052e835500c0" => :mojave
    sha256 "16e31884645c7deca510218f7611d6c2ed105ef5229efcf3f17b4ab7a5f6330c" => :high_sierra
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
