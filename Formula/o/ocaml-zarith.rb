class OcamlZarith < Formula
  desc "OCaml library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/Zarith"
  url "https://github.com/ocaml/Zarith/archive/refs/tags/release-1.14.tar.gz"
  sha256 "5db9dcbd939153942a08581fabd846d0f3f2b8c67fe68b855127e0472d4d1859"
  license "LGPL-2.0-only"
  revision 5

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4f4af8b87fdfada4fc2d5f663d2f29bbf5545d5c6fefb8c42e3a3fbc80cb1095"
    sha256 cellar: :any, arm64_sequoia: "9842f3a1e28611bb3f3434aa496fc42819b074a75c419d6c8776670e5247bad4"
    sha256 cellar: :any, arm64_sonoma:  "02a47b67c765cb427f471f3f37a5cc15b982a57cfb62e65161c8ad4183e0a027"
    sha256 cellar: :any, sonoma:        "7758c035679677929605be1c7fa8519149791ec8400a9b8a3c9f52a7332c57c3"
    sha256 cellar: :any, arm64_linux:   "6bee95138f01362fc0bb3bcf91db9437350829211bad5d07a71df1a572cbbfd1"
    sha256 cellar: :any, x86_64_linux:  "a0bbf8d7541049b4efa4360f9fc40374ef1100159b39ba0b3a58d34cc65f8bac"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "gmp"
  depends_on "ocaml"

  def install
    # Work around for https://github.com/Homebrew/homebrew-test-bot/issues/805
    if ENV["HOMEBREW_GITHUB_ACTIONS"] && !(Formula["ocaml-findlib"].etc/"findlib.conf").exist?
      ENV["OCAMLFIND_CONF"] = formula_opt_libexec("ocaml-findlib")/"findlib.conf"
    end

    ENV["OCAMLFIND_DESTDIR"] = lib/"ocaml"

    (lib/"ocaml").mkpath
    cp formula_opt_lib("ocaml")/"ocaml/Makefile.config", lib/"ocaml"

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
    system formula_opt_bin("ocaml")/"ocamlopt", "-I", lib/"ocaml/zarith",
           "-ccopt", "-L#{lib}/ocaml -L#{formula_opt_lib("gmp")}",
           "zarith.cmxa", "-o", "zq.exe", "zq.ml"
    expected = File.read("zq.output64", mode: "rb")
    assert_equal expected, shell_output("./zq.exe")
  end
end
