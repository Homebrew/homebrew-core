class OcamlZarith < Formula
  desc "OCaml library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/Zarith"
  url "https://github.com/ocaml/Zarith/archive/release-1.12.tar.gz"
  sha256 "cc32563c3845c86d0f609c86d83bf8607ef12354863d31d3bffc0dacf1ed2881"
  license "LGPL-2.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "018f622f9fe43cfb9caf4746f53871738ff03d937132fdfc6fc88151b5d20ba0"
    sha256 cellar: :any,                 arm64_monterey: "ea6cf06fa11e1b9fb4a44b7505fdf63f00c5ed6b8e67cd0169ca0c639faa1289"
    sha256 cellar: :any,                 arm64_big_sur:  "367bc5c6ffa7abf7ecc404d2fc28e2afedb77205dbabd35dd8208e3a602ec4f7"
    sha256 cellar: :any,                 ventura:        "b7dbfb589f9cde13b188e22a0bbd069e630bcd3d19a815a2cb0fbc6c445bf634"
    sha256 cellar: :any,                 monterey:       "340e05d7e78a4d28c4561c93baf0292898e6d0d59595434671c834c75fd9caf3"
    sha256 cellar: :any,                 big_sur:        "03a61531e43d23e530fae1b8fba0baddb8678e14ffa5b5935679514e12ca694e"
    sha256 cellar: :any,                 catalina:       "49571d6a4f0fafe1694845803a87d6e79283573d71b05f4fb56935c4435c6bec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54e08705893555bd10e655f8cf245ac1a781afc0a0fc7accf012e2bffd3e7f49"
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
