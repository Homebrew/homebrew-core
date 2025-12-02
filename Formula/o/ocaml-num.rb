class OcamlNum < Formula
  desc "OCaml legacy Num library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/num"
  url "https://github.com/ocaml/num/archive/refs/tags/v1.6.tar.gz"
  sha256 "b5cce325449aac746d5ca963d84688a627cca5b38d41e636cf71c68b60495b3e"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8ee79694c29aed327203abaa275dee7f5e041f318cd137c3a3eceaf487317cf6"
    sha256 cellar: :any,                 arm64_sequoia: "6ee1ee0d2051f4c239c9237132fa360040acd888fc3f1e22c7d09c8d848dfa23"
    sha256 cellar: :any,                 arm64_sonoma:  "459cea86755ea336dfb81795e7b1bc2109129c4db64190bc1c06e2b90e644418"
    sha256 cellar: :any,                 sonoma:        "10857c605731b1a3f944b1a3c6fcc03a2cca2857faa0ba46e0970413bb4a8b62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "713ed3e565058a66c023563a55c0f53fd44d479b5cf0df611fd734913711837f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1558cfe67cec4a8ce6f51be96437ddcad3a4c0ebc017e8dac395b9aacb2afa70"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "ocaml"

  def install
    ENV["OCAMLFIND_DESTDIR"] = lib/"ocaml"

    # Work around https://github.com/ocaml/num/issues/43
    inreplace "src/Makefile", "cp META.num META", "mv META.num META"

    (lib/"ocaml").mkpath
    cp Formula["ocaml"].opt_lib/"ocaml/Makefile.config", lib/"ocaml"

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
    system Formula["ocaml"].opt_bin/"ocamlopt", "-I", lib/"ocaml", "-I",
           Formula["ocaml"].opt_lib/"ocaml", "-o", "test", "nums.cmxa",
           "test.ml", "test_nats.ml", "test_big_ints.ml", "test_ratios.ml",
           "test_nums.ml", "test_io.ml", "end_test.ml"
    assert_match "1... 2... 3", shell_output("./test")
  end
end
