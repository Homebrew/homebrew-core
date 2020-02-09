class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/archive/V8.11.0.tar.gz"
  sha256 "eea101eff5217dba6d11a8eb13033ed62acb4ee8a64d5cb15fd142e7fc5dc248"
  head "https://github.com/coq/coq.git"

  bottle do
    sha256 "5f6213ba7cb1f3b2dd519f3ca52f9fd4dcb95646b2a6bbd675309ca8b06ca74e" => :catalina
    sha256 "eb1a691cb35a950f4806d5a6eb93660e4337d3ccbb422d55a7b7e6dbeb87bd88" => :mojave
    sha256 "e814994eccc672358885772c71d279e41741d431eaadda392f5d6b43e6cb947b" => :high_sierra
  end

  depends_on "ocaml-findlib" => :build
  depends_on "ocaml"
  depends_on "ocaml-num"

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
