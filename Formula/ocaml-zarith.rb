class OcamlZarith < Formula
  desc "OCaml library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/Zarith"
  url "https://github.com/ocaml/Zarith/archive/release-1.11.tar.gz"
  sha256 "f996af120a10fd06a8272ae99b7affd57cef49c57a3a596e2f589147dd183684"
  license "LGPL-2.0-only"

  bottle do
    cellar :any
    sha256 "f70ad5d11b3a1c4eb35cd249c110a6e764bf2079eaf67f08ff7a253034256170" => :big_sur
    sha256 "ad4a1aa81a4a1d2fc136e07e7574b448bb1a2fa75aaceafc109c5e1426e064f3" => :catalina
    sha256 "51fde5a55a28bba380a16a462d0319626c1340e823d425777e8d9189bcfa6759" => :mojave
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
