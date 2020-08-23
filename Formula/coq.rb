class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/archive/V8.12.0.tar.gz"
  sha256 "ecde14c6132f5abb459e7f4724788788928174ad4484fff88e86b0086779bcee"
  license "LGPL-2.1"
  head "https://github.com/coq/coq.git"

  bottle do
    sha256 "a5554791729dd815ac14788c76b7f4e72970d734fa0fa161709030409cf55f90" => :catalina
    sha256 "ac3b6a5a21b51c4c535255607a0d620665f9747183115ff20a6349bcf863afc1" => :mojave
    sha256 "28d141665e1ca46ead7af4061aff2658712817b6d140b37e69171586e28999f3" => :high_sierra
  end

  depends_on "ocaml-findlib" => :build
  depends_on "ocaml"
  depends_on "ocaml-num"

  uses_from_macos "m4" => :build
  uses_from_macos "unzip" => :build

  def install
    system "./configure", "-prefix", prefix,
                          "-mandir", man,
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
