class OcamlZarith < Formula
  desc "OCaml library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/Zarith"
  url "https://github.com/ocaml/Zarith/archive/refs/tags/release-1.14.tar.gz"
  sha256 "5db9dcbd939153942a08581fabd846d0f3f2b8c67fe68b855127e0472d4d1859"
  license "LGPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "9c6e011f7957d6fb4c36bcd17ebbad4f01aba13815c1835f1398b4e5411517b3"
    sha256 cellar: :any,                 arm64_sonoma:   "515898c18f57cf4f95848363cad9ddc0bcce5822a0cbb19f3a61bd5f28584094"
    sha256 cellar: :any,                 arm64_ventura:  "d9e1fad027a101b902d9fd0c3bfcc58c6b6d4928092d80f9aeb043029ed5743d"
    sha256 cellar: :any,                 arm64_monterey: "a6afc5a2871d654eedf99c6d134f6507cfce542cfe4d41b9460636026bac2090"
    sha256 cellar: :any,                 sonoma:         "4ee869c844b6dd77c9df7e5997c042aeffa2d5ca06e403f689cd896f308040a7"
    sha256 cellar: :any,                 ventura:        "757d2465c37550081fc1ba9b00830f0c406e1c70bef3f0f1a021d226e482866b"
    sha256 cellar: :any,                 monterey:       "1d5b4d9293b256249cc5fbaa84329f95aaf7ee9e20aafd74c9de4b2528231144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e783e507b26e4860a591abdc72e215bd8c067a13142f5cf05d567af392b33d87"
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
