class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/archive/V8.13.1.tar.gz"
  sha256 "95e71b16e6f3592e53d8bb679f051b062afbd12069a4105ffc9ee50e421d4685"
  license "LGPL-2.1-only"
  head "https://github.com/coq/coq.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "0447644917356bc431d9e97b408a84f0cef0f8bf96ea9b849198f244459e3a2e"
    sha256 big_sur:       "6f09e0f0691cc213976a437a39c9898671884b333f2999a694bfe2c480edd7b6"
    sha256 catalina:      "99d041e5c719e86a2a2d99a415e7689e870c08b17d540e2a3d710f6e1761506d"
    sha256 mojave:        "ce88a3dcd0df33a03a99cc2da7517739c4eedceff7e267f5c3485c4108a741b7"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "ocaml"
  depends_on "ocaml-zarith"

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
      Require Coq.micromega.Lia.
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

      Import Coq.micromega.Lia.
      Import Coq.ZArith.ZArith.
      Open Scope Z.
      Lemma add_O_r_Z : forall (n: Z), n + 0 = n.
      Proof.
      intros; lia.
      Qed.
    EOS
    system("#{bin}/coqc", "#{testpath}/testing.v")
  end
end
