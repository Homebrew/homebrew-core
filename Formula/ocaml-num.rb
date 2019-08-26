class OcamlNum < Formula
  desc "OCaml legacy Num library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/num"
  url "https://github.com/ocaml/num/archive/v1.2.tar.gz"
  sha256 "c5023104925ff4a79746509d4d85294d8aafa98da6733e768ae53da0355453de"
  revision 1

  bottle do
    cellar :any
    sha256 "2317af1d75ad805c6b2726c513ef4530a4ad271ff2157e880c8b67a346e49b7f" => :mojave
    sha256 "6d49be0f58ef3b784c4871268c96c50504c8f9639b5fe3df780f3f25dfeae17c" => :high_sierra
    sha256 "d4039e61c189ff9752476b85529fc285d1ed01210290ed1282e0958b411650dd" => :sierra
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
