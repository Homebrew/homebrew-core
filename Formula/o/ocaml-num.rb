class OcamlNum < Formula
  desc "OCaml legacy Num library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/num"
  url "https://github.com/ocaml/num/archive/refs/tags/v1.5.tar.gz"
  sha256 "7ae07c8f5601e2dfc5008a62dcaf2719912ae596a19365c5d7bdf2230515959a"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6d725e2394822cf187d7e62e026e2074d3634cc0d446b99628b940fb17a98fc5"
    sha256 cellar: :any,                 arm64_sonoma:  "0770ab23c6c1522658854b81feee508616d0961ed59df5fce51668b148ec663c"
    sha256 cellar: :any,                 arm64_ventura: "4c8ae18c3e506a523126dfbaa5c0e985403b3755605acd2958e77c8ae8b92ddb"
    sha256 cellar: :any,                 sonoma:        "893b09b47a9314c067180e6ed6aef8ee5409367b879b34c0bcfa9f2f4fb6dbbe"
    sha256 cellar: :any,                 ventura:       "8ac2491b750fcba45378a3078a59c946d05f770a97852e2f6ed300b47b91517f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bea4a13f1bd4a051e1589226b5349defd7d7b61a37817e673c15edc56d9dccdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db6ecc0fac0cfe98ec8caa2f97962d497d9e892aa9064a81490852555f65fc19"
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
