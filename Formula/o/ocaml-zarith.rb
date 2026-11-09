class OcamlZarith < Formula
  desc "OCaml library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/Zarith"
  url "https://github.com/ocaml/Zarith/archive/refs/tags/release-1.14.tar.gz"
  sha256 "5db9dcbd939153942a08581fabd846d0f3f2b8c67fe68b855127e0472d4d1859"
  license "LGPL-2.0-only"
  revision 7
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2796d9feedfae5f9cf45b4742d4eee43c5062b4d6ec765d879be7a2f7021fc14"
    sha256 cellar: :any, arm64_tahoe:       "4b0d2155bccf49bd37725767aa82e1d28bb889423aaaaa180def10dcb3f748b8"
    sha256 cellar: :any, arm64_sequoia:     "00dc5230b27e5cec0baffc31c4177c2216c5061bcf16e8c24cf0ff045257e21e"
    sha256 cellar: :any, arm64_linux:       "a55453e9852a3d2c02a957a6af8d6e8d35e4c3b6c7d9f0979e7d2547d87a0c0f"
    sha256 cellar: :any, x86_64_linux:      "f5c977b53e4226694a0fe5ec3ea78f0e18e195f1c9f461fadaa4e7b446522bc9"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "gmp"
  depends_on "ocaml"

  deny_network_access!

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
