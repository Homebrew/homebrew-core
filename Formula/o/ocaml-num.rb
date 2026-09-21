class OcamlNum < Formula
  desc "OCaml legacy Num library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/num"
  url "https://github.com/ocaml/num/archive/refs/tags/v1.6.tar.gz"
  sha256 "b5cce325449aac746d5ca963d84688a627cca5b38d41e636cf71c68b60495b3e"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 3

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "64ef4bba54eb58566a8f9d9e2c5cddbaa0d80197a385b4e80861144072351ec5"
    sha256 cellar: :any, arm64_tahoe:       "6711653696557e458199537e4074ce062b3dc97ddf61f24d6410869f0781615a"
    sha256 cellar: :any, arm64_sequoia:     "314786a8ae2fc747be701705d460df3f6dfcb5027b692be745ee353da1e7b545"
    sha256 cellar: :any, arm64_linux:       "966e3bfd246f4430cb6e40fadc96da8bf12cbba428e5784ad220531c1b054e7b"
    sha256 cellar: :any, x86_64_linux:      "5eb5e958e50ad24aeb6e007158237c69b8358b68dde62788e727a45181c1d321"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "ocaml"

  def install
    ENV["OCAMLFIND_DESTDIR"] = lib/"ocaml"

    # Work around https://github.com/ocaml/num/issues/43
    inreplace "src/Makefile", "cp META.num META", "mv META.num META"

    (lib/"ocaml").mkpath
    cp formula_opt_lib("ocaml")/"ocaml/Makefile.config", lib/"ocaml"

    # install in #{lib}/ocaml not #{HOMEBREW_PREFIX}/lib/ocaml
    inreplace lib/"ocaml/Makefile.config" do |s|
      s.change_make_var! "prefix", prefix
    end

    ENV.deparallelize { system "make" }
    (lib/"ocaml/stublibs").mkpath # `make install` assumes this directory exists
    system "make", "install", "STDLIBDIR=#{lib}/ocaml"

    pkgshare.install "test"

    rm lib/"ocaml/Makefile.config" # avoid conflict with ocaml
  end

  test do
    cp_r pkgshare/"test/.", "."
    system formula_opt_bin("ocaml")/"ocamlopt", "-I", lib/"ocaml", "-I",
           formula_opt_lib("ocaml")/"ocaml", "-o", "test", "nums.cmxa",
           "test.ml", "test_nats.ml", "test_big_ints.ml", "test_ratios.ml",
           "test_nums.ml", "test_io.ml", "end_test.ml"
    assert_match "1... 2... 3", shell_output("./test")
  end
end
