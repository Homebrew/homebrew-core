class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/rel707.tar.gz"
  version "7.07"
  sha256 "a2c493b833b217adf94d2000eb19015b990c4e441beb35cf36b1d33ed2351991"
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    sha256 "0cdb0b94b785a28f1043e8c40faeb2b9be5ba667efcb4fbe20323b988800780a" => :mojave
    sha256 "532e7fb56feb3c13f4d9a37cffd7e3d5e2539ff3e5d081055c7d704fdbd99801" => :high_sierra
    sha256 "726a57e231f5baa986089594895442dd1edf807352c797edd24d40da69a9c4d0" => :sierra
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
