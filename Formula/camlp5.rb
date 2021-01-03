class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/rel8.00.tar.gz"
  sha256 "906d5325798cd0985a634e9b6b5c76c6810f3f3b8e98b80a7c30b899082c2332"
  license "BSD-3-Clause"
  head "https://github.com/camlp5/camlp5.git"

  livecheck do
    url :homepage
    regex(%r{The current distributed version is <b>v?(\d+(?:\.\d+)+)</b>}i)
  end

  bottle do
    sha256 "3d9f6ac5cf435fafbbeda6c5501b9739c392ae10f323b6f5ba6d3239f0071e59" => :big_sur
    sha256 "c1be8fb086af12081aa3d87cf5612c3a9cb8a0b4fef5b87b57616070189d2e72" => :catalina
    sha256 "4ee98efce126090d985a37c15e1f3a16fecc2b8fbbb247ed7cf202ec2220e058" => :mojave
  end

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
