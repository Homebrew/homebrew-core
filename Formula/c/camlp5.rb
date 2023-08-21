class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/refs/tags/rel8.00.04.tar.gz"
  sha256 "bddbcb5c3c2d410c9a61c4dfb6e46e3bbe984d25ac68221a7a65c82a29956b1d"
  license "BSD-3-Clause"
  head "https://github.com/camlp5/camlp5.git", branch: "master"

  livecheck do
    url :stable
    regex(/^rel[._-]?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "899fe2710188efbca347817a752d5ddb8ce8288434cf2d5911611be932bcc9f3"
    sha256 arm64_monterey: "63f83e1410d36a10a0f7878487126dcb8d1637d99c97584207d8e44dce84e10e"
    sha256 arm64_big_sur:  "c7ca80e8ca739c8648a52da3ee4af318fe5e58de5fc8fdd7c7e08d822f44a512"
    sha256 ventura:        "169409404579083889e4c5703bd717f19c7931b502e5b4f99e89e8d47d5af12b"
    sha256 monterey:       "0576eff6922d5a79b3fdf401259876de4fa628bc2f14190214e47b6dc5210c47"
    sha256 big_sur:        "2dc7634e71780ddb7bd0e6409086fd66073e3044f781dc0614daee7f31922bbb"
    sha256 x86_64_linux:   "f749e0f60738786a289d2f5df57f6d4a82f27679353b059d9f6adf30c7b325ea"
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
