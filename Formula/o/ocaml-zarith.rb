class OcamlZarith < Formula
  desc "OCaml library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/Zarith"
  url "https://github.com/ocaml/Zarith/archive/refs/tags/release-1.14.tar.gz"
  sha256 "5db9dcbd939153942a08581fabd846d0f3f2b8c67fe68b855127e0472d4d1859"
  license "LGPL-2.0-only"
  revision 6

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d6f17210cfd7e55ea7b586b16e62bf7e95cb37cc2deb8210e92da20318142ab1"
    sha256 cellar: :any, arm64_tahoe:       "e78850010ac01002146fc3027fb407cec34ea975e9ad33ba269a33ec6948f479"
    sha256 cellar: :any, arm64_sequoia:     "e601fe3a657d9ca87e2f3c0749444352ee0854c60df4257f4e524f4da1a51411"
    sha256 cellar: :any, arm64_linux:       "7acf38bc8394ff77c6e865c0c4a4bc01e3ca57473f6bc07860a2910f525595e4"
    sha256 cellar: :any, x86_64_linux:      "0bee0df8f82b281850059def01b744d68759ea29e0b879cce7ca1aa421e0896a"
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
