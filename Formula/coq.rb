class Camlp5TransitionalModeRequirement < Requirement
  fatal true

  satisfy(:build_env => false) { !Tab.for_name("camlp5").with?("strict") }

  def message; <<~EOS
    camlp5 must be compiled in transitional mode (instead of --strict mode):
      brew install camlp5
    EOS
  end
end

class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/archive/V8.7.2.tar.gz"
  sha256 "ef25c3979f69b891d40a8776b96059229b06de3d037923de9c657faf8ede78d2"
  head "https://github.com/coq/coq.git"

  bottle do
    sha256 "322a28d2fd675c87def801f418ea9e864f8a248d3a1b8db75f72b5ae27ccaecb" => :high_sierra
    sha256 "636e15aa70244d7a667523dffed1510e08f20268dc76d8b88ea17966000906f2" => :sierra
    sha256 "a94ce424a55a9abac395e56829030707c8cd62fa5a7f136ad8d2202f5d4e6cff" => :el_capitan
  end

  depends_on "ocaml-findlib" => :build
  depends_on Camlp5TransitionalModeRequirement
  depends_on "camlp5"
  depends_on "ocaml"
  depends_on "ocaml-num"

  def install
    system "./configure", "-prefix", prefix,
                          "-mandir", man,
                          "-emacslib", elisp,
                          "-coqdocdir", "#{pkgshare}/latex",
                          "-coqide", "no",
                          "-with-doc", "no"
    system "make", "world"
    ENV.deparallelize { system "make", "install" }
  end

  test do
    (testpath/"testing.v").write <<~EOS
      Require Coq.omega.Omega.
      Require Coq.ZArith.ZArith.

      Inductive nat : Set :=
      | O : nat
      | S : nat -> nat.
      Fixpoint add (n m: nat) : nat :=
        match n with
        | O => m
        | S n' => S (add n' m)
        end.
      Lemma add_O_r : forall (n: nat), add n O = n.
      Proof.
      intros n; induction n; simpl; auto; rewrite IHn; auto.
      Qed.

      Import Coq.omega.Omega.
      Import Coq.ZArith.ZArith.
      Open Scope Z.
      Lemma add_O_r_Z : forall (n: Z), n + 0 = n.
      Proof.
      intros; omega.
      Qed.
    EOS
    system("#{bin}/coqc", "#{testpath}/testing.v")
  end
end
