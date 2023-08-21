class OcamlZarith < Formula
  desc "OCaml library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/Zarith"
  url "https://github.com/ocaml/Zarith/archive/release-1.13.tar.gz"
  sha256 "a5826d33fea0103ad6e66f92583d8e075fb77976de893ffdd73ada0409b3f83b"
  license "LGPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6ea3674d28c24ef63bbe635871fbac608eb8215370058e8bb067e52fac64ad31"
    sha256 cellar: :any,                 arm64_monterey: "f19a7da2a824ac3881aeb88979badb774fd3f5181908b6280961b7bc7b031b9e"
    sha256 cellar: :any,                 arm64_big_sur:  "d79d6bb89cb272f3dbaed00db063e3e8e50de18b37a6e6193c69980d3a27f7a4"
    sha256 cellar: :any,                 ventura:        "2395358b13bed8bc9cf57f891bf9d3cf5576154df991869dbe7613ce1403e71a"
    sha256 cellar: :any,                 monterey:       "2dc837f6b5b386f2903d62b044736474561083c866727bf65b7fea8cbd7ed0a1"
    sha256 cellar: :any,                 big_sur:        "e062e7f558a9d3e4115126e5255d28908ee5800803d41fa5681119c75a2c94ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4133fea100b0af1214fb2fb9ba1db745f4ffb8702726b9744c153750f00948c"
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
