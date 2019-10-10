class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/archive/V8.10.0.tar.gz"
  sha256 "292c64162620c4c4825c323c1c71762d764ebc9ce39bd8eee900851eaca655f5"
  head "https://github.com/coq/coq.git"

  bottle do
    sha256 "e4fe07c67883dee1248c8100ecf361fcb7cb6eb0e841e72a6816d81789119268" => :catalina
    sha256 "49b5536de76d034c5bba92a7229dd61090fd35709f59e88cf9c7ea26a5f2d414" => :mojave
    sha256 "b7eeedfbfcc42464fd50e3e579b6f986068a3a7f50e1da06c153a22097b3ca09" => :high_sierra
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
