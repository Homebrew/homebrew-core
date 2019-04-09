class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/archive/V8.9.0.tar.gz"
  sha256 "8bd6e2bc8d79f96df19b8888ebfbdfdbe50fa9cd3fb969c13b610f7d05070ff0"
  head "https://github.com/coq/coq.git"

  bottle do
    sha256 "0b56d57a006cabfcba72986ee8e4d7154ea8d764bf2ca2921c9ee894e166d033" => :mojave
    sha256 "fc3c71b442caa68b3a40a5143ebd272eb93ded575fcee2a72c81ebd791f42906" => :high_sierra
    sha256 "8506c6f6304ae35782dda12751c4ff2b22474dbcd6f9e41eb390801314eb6f68" => :sierra
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
