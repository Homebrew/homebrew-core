class Camlp5TransitionalModeRequirement < Requirement
  fatal true

  satisfy(:build_env => false) { !Tab.for_name("camlp5").with?("strict") }

  def message; <<-EOS.undent
    camlp5 must be compiled in transitional mode (instead of --strict mode):
      brew install camlp5
    EOS
  end
end

class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://coq.inria.fr/distrib/8.5pl3/files/coq-8.5pl3.tar.gz"
  version "8.5pl3"
  sha256 "305b92e05d406d4d0c64f43d4fadb6b89419120a1d4ae4115ed1c5eb8812d33b"
  revision 1
  head "git://scm.gforge.inria.fr/coq/coq.git", :branch => "trunk"

  bottle do
    sha256 "6db2fb10d915a9de824deb4409f5b6f9ef63b209d76597912f3e6e2fd40de25b" => :sierra
    sha256 "e317d1b14e98abd0813fb3978ce94a4451201443610d8f9ecc0c65ac1d64f8ef" => :el_capitan
    sha256 "17f5b15170776cebc527478b1b6247036682888fe2a270ab614febbd0f1b4326" => :yosemite
  end

  depends_on Camlp5TransitionalModeRequirement
  depends_on "camlp5"
  depends_on "ocaml"

  def install
    camlp5_lib = Formula["camlp5"].opt_lib/"ocaml/camlp5"
    system "./configure", "-prefix", prefix,
                          "-mandir", man,
                          "-camlp5dir", camlp5_lib,
                          "-emacslib", elisp,
                          "-coqdocdir", "#{pkgshare}/latex",
                          "-coqide", "no",
                          "-with-doc", "no"
    system "make", "world"
    ENV.deparallelize { system "make", "install" }
  end

  test do
    (testpath/"testing.v").write <<-EOS.undent
      Inductive nat : Set :=
      | O : nat
      | S : nat -> nat.
      Fixpoint add (n m: nat) : nat :=
        match n with
        | O => m
        | S n' => S (add n' m)
        end.
      Lemma add_O_r : forall (n: nat), add n O = n.
      intros n; induction n; simpl; auto; rewrite IHn; auto.
      Qed.
    EOS
    system("#{bin}/coqc", "#{testpath}/testing.v")
  end
end
