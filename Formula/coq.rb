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
  url "https://github.com/coq/coq/archive/V8.8.0.tar.gz"
  sha256 "caf7c1d39e68e0e41ed92be1d57c88983fb12edb9fa95667a5ad2d6aba98263d"
  head "https://github.com/coq/coq.git"

  bottle do
    sha256 "9472d829ce611df12cd613fb8b4efd7bf78c732b619147e459829c60498583b2" => :high_sierra
    sha256 "1205cdb57164c6d391d9dbf1fcb5a81ec6651f74ee33446c6f9f1fd2f7820ccc" => :sierra
    sha256 "5c86c745cc2e96d7d80088936fe651d4576428f168350f54074e44f6e8d5473a" => :el_capitan
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
