class OcamlNum < Formula
  desc "OCaml legacy Num library for arbitrary-precision arithmetic"
  homepage "https://github.com/ocaml/num"
  url "https://github.com/ocaml/num/archive/refs/tags/v1.6.tar.gz"
  sha256 "b5cce325449aac746d5ca963d84688a627cca5b38d41e636cf71c68b60495b3e"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "76c722dd8ad6f12ccdda09f952f5f6b0ac5d240c4bbb4ded7d78915cea582c3f"
    sha256 cellar: :any,                 arm64_sequoia: "6e7f4d21c10922367590c1edce13ed4864b6aa7b75ed33d5533f0b08f9b3c101"
    sha256 cellar: :any,                 arm64_sonoma:  "93da978a25ffe78f43852b07dd2dee9c06de67534ffaf389e96e8b5d3d152a2b"
    sha256 cellar: :any,                 sonoma:        "b7eb0c9fbb0d0c9fc3234011c0954abea2c44774aeda331094897ed1363f37d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1582f04ba6900e23021d99ef4450ae945935fde491e4fae1a24f05c22a690417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "594ea85e889f5063ea86712ffc6930e71597c8b438b5d82663e925fdfdebd47b"
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
