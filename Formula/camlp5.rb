class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/refs/tags/rel8.00.03.tar.gz"
  sha256 "1a710e2a6dbb0f4440867850d605f31fe8407ee8a56c9e067866e34e584385b4"
  license "BSD-3-Clause"
  head "https://github.com/camlp5/camlp5.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{The current distributed version is <b>v?(\d+(?:\.\d+)+)</b>}i)
  end

  bottle do
    sha256 arm64_monterey: "0bed63661d001957196f1eed059f5b33d2c94ec7ef6ae53fd14cf44729733d27"
    sha256 arm64_big_sur:  "ed57354104f665d458cd4d19596129d7a1d811713b03ffdbae806fa71e7de0c5"
    sha256 monterey:       "a11f84037af3fa99c6cc6428daa58412b1fd1d32177c684bcdc84909f9684347"
    sha256 big_sur:        "c4b79325ed05ecbaf4b7bd0ad806c63766a9ecf2606293675f0cd8744e05dc2e"
    sha256 catalina:       "ab486332051f9133a5ec9a8b1bf0e51653ad850bce9e8f01ecf61b491483cd3f"
    sha256 x86_64_linux:   "31f9d0038fb7af7fa9bb9934a1261917b1ebc63a5a89298e89f3088faadde3c4"
  end

  depends_on "ocaml-findlib" => :build
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
