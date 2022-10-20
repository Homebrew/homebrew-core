class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/refs/tags/rel8.00.03.tar.gz"
  sha256 "1a710e2a6dbb0f4440867850d605f31fe8407ee8a56c9e067866e34e584385b4"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/camlp5/camlp5.git", branch: "master"

  livecheck do
    url :stable
    regex(/^rel[._-]?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "9daedd1054de7c0004d21f643d47ea90611f66d13524488950e5fbe36bf8c0b4"
    sha256 arm64_big_sur:  "328cb38eb6fc4540c35bca367e55c26f5e088dd0d2f0858bed6508f21ff470f7"
    sha256 monterey:       "dc109b253d4a8393e83abe312ed7d372795efabf4d2ed32c0e4ea132ac473822"
    sha256 big_sur:        "89414654ad17bd67769884a1f1f5f0b04ba7f822b41ec87821adec5e81323c6d"
    sha256 catalina:       "361e38d25555a16220746683a9ff4483683d75cf1cf711140cc94c6cfd9931b9"
    sha256 x86_64_linux:   "915b81cd45db3bad023f43efed93f1b5dafbff1c1c539244f06ce02f124f2311"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "camlp-streams"
  depends_on "ocaml"

  def install
    system "./configure", "--prefix", prefix, "--mandir", man
    system "make", "world.opt"
    system "make", "install"
    (lib/"ocaml/camlp5").install "etc/META"
  end

  test do
    ocaml = Formula["ocaml"]
    (testpath/"hi.ml").write "print_endline \"Hi!\";;"
    assert_equal "let _ = print_endline \"Hi!\"",
      # The purpose of linking with the file "bigarray.cma" is to ensure that the
      # ocaml files are in sync with the camlp5 files.  If camlp5 has been
      # compiled with an older version of the ocaml compiler, then an error
      # "interface mismatch" will occur.
      shell_output("#{bin}/camlp5 #{lib}/ocaml/camlp5/pa_o.cmo #{lib}/ocaml/camlp5/pr_o.cmo " \
                   "#{ocaml.opt_lib}/ocaml/bigarray.cma hi.ml")
  end
end
