class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/archive/V8.8.2.tar.gz"
  sha256 "f9f843b21fda18195fbf80c706bce8ac70ccb43cbd82f6916747dc6c22d05044"
  head "https://github.com/coq/coq.git"

  bottle do
    sha256 "45d2d54d36f617c14ba51b947b1b018d53c035d03adfc0025e69972560301136" => :mojave
    sha256 "07db19453e504dcc0ec4ea96e54c4b7bcbee6fd9126dd2da0c0ad179ede6237e" => :high_sierra
    sha256 "5598f52047139121c42cea869f01ed54b6f66e787918664f173e36bae5963e43" => :sierra
  end

  depends_on "ocaml-findlib" => :build
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
