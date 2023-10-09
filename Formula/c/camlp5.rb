class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/refs/tags/8.02.01.tar.gz"
  sha256 "58d4bce0c20fa1151fc2c15f172f5884472e2044a4b0da22aababf46c361e515"
  license "BSD-3-Clause"
  head "https://github.com/camlp5/camlp5.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:rel[._-]?)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "68bc1221b21f49d08586934bc06f19a62eef0308b92aa6257b5313e3f97e08e3"
    sha256 arm64_ventura:  "b66cf027c5621a927617b974a01507b903b60f92aed85458b50bd1571241cb69"
    sha256 arm64_monterey: "3176a9e4b1bf08b23615ada8387811cf2d63b8acbc18d1e1d4645007350a0bab"
    sha256 arm64_big_sur:  "087ce00b6ef3367386236ba7832c658b01fe0e41288647f4a9a41dd304e6aebd"
    sha256 sonoma:         "056cdf35c1cc5a6dfac714380f69cc3851d535464ef347af7ed70a866ddb3015"
    sha256 ventura:        "7043d9895aa1e64a3ac4a7a9f26778770dd91b17a8507e35b43614f84d7dac21"
    sha256 monterey:       "dcbffb83005849f1446742c2ba704577a495e2ef9ca82375d87b03d76640d977"
    sha256 big_sur:        "dcc8d08791e3b42d7faba7faeebc3dc2c0fd17d23b730ad5a4dd468ad5d4d862"
    sha256 x86_64_linux:   "16ba10a0ccfbda37bbed0d5513c5c7d4f82e5f7b40c102c48024429ddd4635d2"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "opam" => :build
  depends_on "camlp-streams"
  depends_on "ocaml"

  uses_from_macos "m4" => :build

  def install
    opamroot = buildpath/".opam"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"

    system "opam", "init", "--no-setup", "--disable-sandboxing"
    system "opam", "exec", "--", "opam", "install", ".", "--deps-only", "-y", "--no-depexts"

    system "./configure", "--prefix", prefix, "--mandir", man
    system "opam", "exec", "--", "make", "world.opt"
    system "opam", "exec", "--", "make", "install"
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
