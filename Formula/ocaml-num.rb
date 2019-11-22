class OcamlNum < Formula
  desc "OCaml legacy Num library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/num"
  url "https://github.com/ocaml/num/archive/v1.2.tar.gz"
  sha256 "c5023104925ff4a79746509d4d85294d8aafa98da6733e768ae53da0355453de"
  revision 1

  bottle do
    cellar :any
    sha256 "30c8c4e2925aec9055c637286a678b8b2b8e35660deaf410dcf50089238c0246" => :catalina
    sha256 "0181124dda2a3a5c35cbf1155712526b99bbc402df14b24cc532b9a6ef8b06e9" => :mojave
    sha256 "bcaa0380dc03f7095cd4b00656ae3b4e1cbe66c8519cbbe7eab63efa76e31503" => :high_sierra
    sha256 "819a3ceaa82022ec9b8019610d906d4520752810dcb688595c23e8cf25051b57" => :sierra
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
