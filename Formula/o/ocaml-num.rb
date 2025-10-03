class OcamlNum < Formula
  desc "OCaml legacy Num library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/num"
  url "https://github.com/ocaml/num/archive/refs/tags/v1.5.tar.gz"
  sha256 "7ae07c8f5601e2dfc5008a62dcaf2719912ae596a19365c5d7bdf2230515959a"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 3

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "809ea16a1084fe15c05b7cd922e3e961c917b2fde56c874da6857e9dae30f240"
    sha256 cellar: :any,                 arm64_sequoia: "781da529cdba86087750a800642a8cc2299be1d255149daff379164073ce7785"
    sha256 cellar: :any,                 arm64_sonoma:  "ce6ae8fa010523ccf585e594d8822f0756f25b188ad869b191fa9bdd11294c01"
    sha256 cellar: :any,                 arm64_ventura: "73245a4b0918db27313822585644728b34ca7b22d1fc4d765321c00f71d4d549"
    sha256 cellar: :any,                 sonoma:        "3348af9bf9743fb08b24d8ca2b0c33c6ce5aa2ccad30af20eca1fb56ca1365cc"
    sha256 cellar: :any,                 ventura:       "47b73fc8a4b41adcf949df605dd13c99f3387d0118aafd7f9795aea53fcd7062"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e692a6429d05500c5958081b2a5c863913b9d62a23d88bf692ba76fd34988bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19bc0687d271a60a5acc1f4b8fd6d0a52c9d27ce3a4271760b39ea36ddaef17c"
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
