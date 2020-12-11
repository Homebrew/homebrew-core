class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/archive/V8.12.2.tar.gz"
  sha256 "2c57416e3ec737b212610512eae7e40259fb17a4e487b49981556f28838e8b17"
  license "LGPL-2.1-only"
  head "https://github.com/coq/coq.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "a48a662668ade325781a8ce65da3de1dc37f97a4fe28839d7dc6b410ea766331" => :big_sur
    sha256 "829b50bb3170e75c5f03f5f2a6260ab6a4fb15d924eae46b510d6e0e1f21fbef" => :catalina
    sha256 "7de6bce7d480b06cb46ebbee170d3c723fd93373e2903573d2e286b96319c5c9" => :mojave
    sha256 "e411c3338f14185e41269693fd481db3e37ed7115038a0ccbdda3589381abce6" => :high_sierra
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
