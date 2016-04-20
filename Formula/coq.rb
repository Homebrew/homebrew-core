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
  url "https://coq.inria.fr/distrib/8.5pl1/files/coq-8.5pl1.tar.gz"
  version "8.5pl1"
  sha256 "4bfa75b10ae1be61301d0f7bc087b7c24e0b8bd025dd358c75709ac04ddd5df0"

  head "git://scm.gforge.inria.fr/coq/coq.git", :branch => "trunk"

  bottle do
    sha256 "3d632ef3f1412b32893693c169f599c42e0e140bea0ce088895c05b6b3bcdabe" => :el_capitan
    sha256 "5675dbdee88a87e5e2200a82f51aac37e7410657ef9c0e28b8551f45d7ecc787" => :yosemite
    sha256 "5bbf0f5893b9d96e13ba123d9c63c2c8e83ed1e6f2e283f53dfc63cc591e745f" => :mavericks
  end

  depends_on Camlp5TransitionalModeRequirement
  depends_on "camlp5"
  depends_on "ocaml"

  def install
    camlp5_lib = Formula["camlp5"].opt_lib+"ocaml/camlp5"
    system "./configure", "-prefix", prefix,
                          "-mandir", man,
                          "-camlp5dir", camlp5_lib,
                          "-emacslib", "#{share}/emacs/site-lisp/coq",
                          "-coqdocdir", "#{pkgshare}/latex",
                          "-coqide", "no",
                          "-with-doc", "no"
    ENV.j1 # Otherwise "mkdir bin" can be attempted by more than one job
    system "make", "world"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    To use the Coq Emacs mode, add the following to your init file:
      (setq auto-mode-alist (cons '("\\\\.v$" . coq-mode) auto-mode-alist))
      (autoload 'coq-mode "coq" "Major mode for editing Coq vernacular." t)
    EOS
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
