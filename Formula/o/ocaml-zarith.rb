class OcamlZarith < Formula
  desc "OCaml library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/Zarith"
  url "https://github.com/ocaml/Zarith/archive/refs/tags/release-1.14.tar.gz"
  sha256 "5db9dcbd939153942a08581fabd846d0f3f2b8c67fe68b855127e0472d4d1859"
  license "LGPL-2.0-only"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a5f328838a9fb4010132b59a63e5c0df644c9193377b500a0ff4e10bd83ee925"
    sha256 cellar: :any,                 arm64_sequoia: "e3125a63143f1bf107f2760cab2e839500705fad697a9b98bdd566df97c97705"
    sha256 cellar: :any,                 arm64_sonoma:  "06bdae53e7838821893c5cfd0a547fb4531732a2f84aceaf34537672cb3f20a7"
    sha256 cellar: :any,                 sonoma:        "7eeba2fab635c73bae503c4f7188af67412ffd4f6a16b7eaa81e1bd206ef7839"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43c9bf11d4fca48437a3f8a146be4bd517a79faa566d4fcf1b81d4afebf435d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72e1e830a5e594e3bd966df2e426ff5c19c89aed7176cc5a277032017792a669"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "gmp"
  depends_on "ocaml"

  def install
    # Work around for https://github.com/Homebrew/homebrew-test-bot/issues/805
    if ENV["HOMEBREW_GITHUB_ACTIONS"] && !(Formula["ocaml-findlib"].etc/"findlib.conf").exist?
      ENV["OCAMLFIND_CONF"] = Formula["ocaml-findlib"].opt_libexec/"findlib.conf"
    end

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
