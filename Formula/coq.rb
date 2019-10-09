class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/archive/V8.10.0.tar.gz"
  sha256 "292c64162620c4c4825c323c1c71762d764ebc9ce39bd8eee900851eaca655f5"
  head "https://github.com/coq/coq.git"

  bottle do
    sha256 "4154be5e0ad0cfd0aedab90e08cd4b10c414463be65a83ebcffa1572ecfdc2f0" => :mojave
    sha256 "fc27156212ecad4d36cf01e394b767b1d6e94c35618b544a931ecf17ff99e22e" => :high_sierra
    sha256 "48b6101a91cbefdb0a758e82018ddf404145e8f79f31af31f81512722dee7d36" => :sierra
  end

  depends_on "ocaml-findlib" => :build
  depends_on "camlp5"
  depends_on "ocaml"
  depends_on "ocaml-num"

  def install
    system "./configure", "-prefix", prefix,
                          "-mandir", man,
                          "-coqdocdir", "#{pkgshare}/latex",
                          "-coqide", "no",
                          "-with-doc", "no"
    # building the compiler in parallel fails due to upstream bug:
    # https://github.com/coq/coq/issues/10864
    # once fixed, delete this line and the compiler will be built with
    # parallelism as part of "make world"
    ENV.deparallelize { system "make", "coqbinaries" }
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
