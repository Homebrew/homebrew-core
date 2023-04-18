class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/archive/V8.17.0.tar.gz"
  sha256 "712890e4c071422b0c414f260a35c5cb504f621be8cd2a2f0edfe6ef7106a1af"
  license "LGPL-2.1-only"
  head "https://github.com/coq/coq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "715af2296ba26df18e0df419ef4d2b7250fb7354a78c3214498f8af00a38ac78"
    sha256 arm64_monterey: "bdca19f84975b8698d84260ee55f59f19eb34e1af4c1fee31ed75cc6e8a4b029"
    sha256 arm64_big_sur:  "5643ee00cf11445ad8315d6b612abbd97585c64c0b390f4ab282e762c7c4d9b2"
    sha256 ventura:        "6aa2e65eb798cf710a3d9520ff137000a9663efda3a7f7c3b0b2370f0d082b08"
    sha256 monterey:       "a7e68f44e997a310037751a9779b16684fcf1d1d60a05ead493a8973ce1954a2"
    sha256 big_sur:        "73671c9f3566797a625d6253f26afb3f58c58b657cca5865b02a3311daf0d938"
    sha256 x86_64_linux:   "c9cf6b50527431e4a5651b78bfff793cde64a98895f51f422afd87efb378fc8d"
  end

  depends_on "dune" => :build
  depends_on "gmp"
  depends_on "ocaml"
  depends_on "ocaml-findlib"
  depends_on "ocaml-zarith"

  uses_from_macos "m4" => :build
  uses_from_macos "unzip" => :build

  def install
    ENV.prepend_path "OCAMLPATH", Formula["ocaml-zarith"].opt_lib/"ocaml"
    ENV.prepend_path "OCAMLPATH", Formula["ocaml-findlib"].opt_lib/"ocaml"
    system "./configure", "-prefix", prefix,
                          "-mandir", man,
                          "-docdir", pkgshare/"latex"
    system "make", "dunestrap"
    system "dune", "build", "-p", "coq-core,coq-stdlib,coq"
    system "dune", "install", "--prefix=#{prefix}", "--mandir=#{man}", "coq-core", "coq-stdlib", "coq"
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
    system bin/"coqc", testpath/"testing.v"
  end
end
