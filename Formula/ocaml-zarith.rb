class OcamlZarith < Formula
  desc "OCaml library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/Zarith"
  url "https://github.com/ocaml/Zarith/archive/release-1.11.tar.gz"
  sha256 "f996af120a10fd06a8272ae99b7affd57cef49c57a3a596e2f589147dd183684"
  license "LGPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "54144ec55af567f0b567f945dac178de3d20ce3dc211b73bbaee75776cd24603"
    sha256 cellar: :any, big_sur:       "3d9670dc7a85d27d20275f814ba281874d178ad3d472a47358383d90f7b60633"
    sha256 cellar: :any, catalina:      "344b8ec7a138d599d34a72809fc3ba6707adf6185fd46733fae19da13fd5e4c9"
    sha256 cellar: :any, mojave:        "e94d949812a3ff7d9142a25c7a17b32b4b049631f97a1e0cbfed2ccea1261028"
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
