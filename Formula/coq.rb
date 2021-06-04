class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/archive/V8.13.2.tar.gz"
  sha256 "1e7793d8483f1e939f62df6749f843df967a15d843a4a5acb024904b76e25a14"
  license "LGPL-2.1-only"
  head "https://github.com/coq/coq.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "1471fe7afec4c1ed3580071dc6d36e1150fc43d2fb323c5e36fe4b3d7562420a"
    sha256 big_sur:       "4592a482157e17284fe52fa9d7966e952a212a9bcbb53936f6431abd9f4fed25"
    sha256 catalina:      "9d1deb99aa8cc14f240462656f1a6cf3191b1cb168ac0f572f78f80cfc69e44d"
    sha256 mojave:        "cd645950af03d8ef9f062e42397edac1c2c9b03afcb49dcf50256ca3cbcc9a14"
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
