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
    sha256 arm64_monterey: "4e9d1250091a2c965ef8870806c20c8aeec04ecd14c15f98d3d71103271b8f20"
    sha256 arm64_big_sur:  "549ee3a8bfbc3b3d6f466087562d15fd1e1b1b092786c488ae3109c19b1ca50d"
    sha256 monterey:       "8c3a3a59d9cf228c480b49ff3c0d4ff77f5be92e301d2017f1462e86d16e6ae4"
    sha256 big_sur:        "a01dea02114f9eb35e8d151ea3b61c34c7fcf5c2db09583cc3480a010211e7b3"
    sha256 catalina:       "14d9affdc0d1aaeef2a2e122523acba47d3b271f7002c66e407e02387f48b1fe"
    sha256 mojave:         "6b753cfd90a18e4d813cfc9ce3d3345547a0424527c15d51304621c9f6689b14"
    sha256 x86_64_linux:   "bf2ef6220fef116a8deb1cc76be1172c98b764a36980317aa81fe44eb2cc4354"
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
