class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/archive/V8.11.2.tar.gz"
  sha256 "98cb9e12ba2508a1ca59e0c638fce27bf95c37082b6f7ce355779b80b25e1bfd"
  head "https://github.com/coq/coq.git"

  bottle do
    sha256 "d59f03425ecdc2f904fd492996559a62ae9de11b7c80095913cecd7aee4ce876" => :catalina
    sha256 "deb0c46797b5ef1f57420938278b8f7e2626e0c3a3225f12e07383ea1e8f530d" => :mojave
    sha256 "cb85d3d2260c1ee93a1e05cdd0a3a61ccd77ddf7048d0ff0bd3db641bdbadeb8" => :high_sierra
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
