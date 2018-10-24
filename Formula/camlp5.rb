class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/rel706.tar.gz"
  version "7.06"
  sha256 "bea3fba40305b6299a4a65a26f8e1f1caf844abec61588ff1c500e9c05047922"
  revision 1
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    sha256 "0266c5d227110ebd1a11b996839b091d60782ba774dcd18c4f4fc4c876e6f060" => :mojave
    sha256 "044c01c3f34815c6543ccb36c83a6b6cf6cc84295a481917f8223572642a14c4" => :high_sierra
    sha256 "e6fc58025ad5da8c8bce65ec5d3ab274e932a905c60043796de97c9dde4f7135" => :sierra
    sha256 "f8561228e8b21eeaf36d56b56550c26cc8ddfe84b87489b5855f38d8902e3d08" => :el_capitan
  end

  depends_on "ocaml"

  def install
    system "./configure", "--prefix", prefix, "--mandir", man
    system "make", "world.opt"
    system "make", "install"
    (lib/"ocaml/camlp5").install "etc/META"
  end

  test do
    (testpath/"hi.ml").write "print_endline \"Hi!\";;"
    assert_equal "let _ = print_endline \"Hi!\"",
      shell_output("#{bin}/camlp5 #{lib}/ocaml/camlp5/pa_o.cmo #{lib}/ocaml/camlp5/pr_o.cmo hi.ml")
  end
end
