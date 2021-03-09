class OcamlZarith < Formula
  desc "OCaml library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/Zarith"
  url "https://github.com/ocaml/Zarith/archive/release-1.12.tar.gz"
  sha256 "cc32563c3845c86d0f609c86d83bf8607ef12354863d31d3bffc0dacf1ed2881"
  license "LGPL-2.0-only"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e7889e5af493114347ecb79b2055497248c79b8feabb40ce94334c97df66999e"
    sha256 cellar: :any, big_sur:       "44f2142166493aa89d13d042e76238c4aada07b461c71f6e2c0558a9ef16ba15"
    sha256 cellar: :any, catalina:      "3e5a15ac5d4739779053dccc3d32a6db4d8a3e2f0dd907e1b522a07d9f40ecf2"
    sha256 cellar: :any, mojave:        "eb1c4799beaf503ca9f29eb92ba9d6e84a01ee38c164f8e60aa4a4f6921ec153"
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
    expected = IO.read("zq.output64", mode: "rb")
    assert_equal expected, shell_output("./zq.exe")
  end
end
