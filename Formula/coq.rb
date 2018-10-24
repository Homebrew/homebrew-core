class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/archive/V8.8.1.tar.gz"
  sha256 "c852fef30f511135993bc9dbed299849663d0096a72bf0797a133f86deda9e8d"
  head "https://github.com/coq/coq.git"

  bottle do
    sha256 "2738358e5a1ffac095a9ac7e20c9562ece444ac66baf82f8492274c60d0d5e3f" => :mojave
    sha256 "e0d8da0099992c2de50cbc3264aea7c0a3c6ad9238c39a8c22137debc5adaa3f" => :high_sierra
    sha256 "a4cf3ba3ae5b3c9d748b07be8d18786ffd178975dbd0b471c5f399f966c46241" => :sierra
    sha256 "cee62528a526eef69eac559fe8ed89d77b84f77dbcaffe3b219f7bb977ab153d" => :el_capitan
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
