class OcamlZarith < Formula
  desc "OCaml library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/Zarith"
  url "https://github.com/ocaml/Zarith/archive/release-1.12.tar.gz"
  sha256 "cc32563c3845c86d0f609c86d83bf8607ef12354863d31d3bffc0dacf1ed2881"
  license "LGPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bab7865c8b5616ad638197376c590dd7bde6740c338c4729bc3c1eafbb1f2192"
    sha256 cellar: :any,                 arm64_big_sur:  "0c3cce93d88d87b8b128773e559179cb422b954e4454c25202b17b3445e4af0f"
    sha256 cellar: :any,                 monterey:       "84328ddca7f27827c955400cfed49f56487cd2f48de9b67fb690d1d95ad7d852"
    sha256 cellar: :any,                 big_sur:        "503c0161d43c38d83ca74b3860158f16a57fa17cd65d8c5a2d7faf3c833617d6"
    sha256 cellar: :any,                 catalina:       "3a8f9f2889bf97dc71933e7c4c2e924dcde23f89c76febce45e6e48c0324f319"
    sha256 cellar: :any,                 mojave:         "8a5b07c6216820cf1929027f3768d0eceeca1676ff17cf5a5cd923fa34e1746d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a826c47a727dafe35794519d24236caa5c532499efc588c804fbc30be4a2b4b"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "gmp"
  depends_on "ocaml"

  def install
    ENV["OCAMLFIND_DESTDIR"] = lib/"ocaml"

    (lib/"ocaml").mkpath
    cp Formula["ocaml"].opt_lib/"ocaml/Makefile.config", lib/"ocaml"

    # install in #{lib}/ocaml not #{HOMEBREW_PREFIX}/lib/ocaml
    inreplace lib/"ocaml/Makefile.config" do |s|
      s.change_make_var! "prefix", prefix
    end

    ENV.deparallelize
    system "./configure"
    system "make"
    (lib/"ocaml/stublibs").mkpath # `make install` assumes this directory exists
    system "make", "install", "STDLIBDIR=#{lib}/ocaml"

    pkgshare.install "tests"

    rm lib/"ocaml/Makefile.config" # avoid conflict with ocaml
  end

  test do
    cp_r pkgshare/"tests/.", "."
    system Formula["ocaml"].opt_bin/"ocamlopt", "-I", lib/"ocaml/zarith",
           "-ccopt", "-L#{lib}/ocaml -L#{Formula["gmp"].opt_lib}",
           "zarith.cmxa", "-o", "zq.exe", "zq.ml"
    expected = File.read("zq.output64", mode: "rb")
    assert_equal expected, shell_output("./zq.exe")
  end
end
