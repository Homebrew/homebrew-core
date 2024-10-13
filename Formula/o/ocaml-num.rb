class OcamlNum < Formula
  desc "OCaml legacy Num library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/num"
  url "https://github.com/ocaml/num/archive/refs/tags/v1.5.tar.gz"
  sha256 "7ae07c8f5601e2dfc5008a62dcaf2719912ae596a19365c5d7bdf2230515959a"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a50336b3ee1e973d360acb08d7b62f6945d73242a312ea047a1ad51912d96261"
    sha256 cellar: :any,                 arm64_sonoma:   "7e7b2d6adfef7295f25999b02b580412d2fa696c6930b664c012a3de467d3573"
    sha256 cellar: :any,                 arm64_ventura:  "75917ef34c2d9db4edb9e26c4032ed90e88b5b9c60d269a9d3eeec2d064b0010"
    sha256 cellar: :any,                 arm64_monterey: "9e62643f96acfd3196326a958182691dac900fab5968460d4b94278e90c5a862"
    sha256 cellar: :any,                 sonoma:         "82b313f948966c3e7ac0871dec7b2a086454c52701010a88a2f3eafea402db7b"
    sha256 cellar: :any,                 ventura:        "3efd7a7c5e693579e750fbdf013e1cf709b31abe7bf41085b2223a31fcae5741"
    sha256 cellar: :any,                 monterey:       "6d0fcf3f73719c755a40b41ca397a0210ac1ee336fb37685a3674673ae526de8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8bd4fec57bb98c82767df5d77937b67170256cf20a67b9335ed30de3248ab75"
  end

  depends_on "ocaml-findlib" => :build
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

    system "make"
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
