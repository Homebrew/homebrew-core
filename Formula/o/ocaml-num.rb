class OcamlNum < Formula
  desc "OCaml legacy Num library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/num"
  url "https://github.com/ocaml/num/archive/refs/tags/v1.6.tar.gz"
  sha256 "b5cce325449aac746d5ca963d84688a627cca5b38d41e636cf71c68b60495b3e"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 4

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8349429bb4a3cdb4f9b0e738059f01514795d86f33ef261674282370abbb1338"
    sha256 cellar: :any, arm64_tahoe:       "ef15b3831114422acc88995db4eec4e9aee44ad456f55c7c3f60c34396f1abc6"
    sha256 cellar: :any, arm64_sequoia:     "02ac14d66bc42588f9a2cf29e41cb21fe1b7b3809704ccb7bdbe848f4ea1308a"
    sha256 cellar: :any, arm64_linux:       "68e1f62ca8dd2ab506a736ab3ee0d7856dd99a9fea748dd90d48c3b295350cb5"
    sha256 cellar: :any, x86_64_linux:      "4ba99c3802dcf641cbdc8340b580f02ef33033d1ae23bc6cf65c6ecd191a3d81"
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
