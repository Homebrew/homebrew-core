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
    sha256 arm64_ventura:  "aff2a9150694707e18c31c4d6ade5fb3e1c8c6716f7cc4a6a657877336940925"
    sha256 arm64_monterey: "0d9e3a32437f36132cd5fe797be914aa4442289d72831fcd6f077ff566dcc8d7"
    sha256 arm64_big_sur:  "308b07a1712a2940fc91ef0830a4e7aa2bcde4131f9b6cb5a3f88726816fa87c"
    sha256 ventura:        "9990d885c2547c1c23e9a29e5960d9e19ec55082704afd05e46d1e913963d1b3"
    sha256 monterey:       "af3439249d6ddbb5af4d06f710787e73111fe5f079fb0009febc7cd89a0418ab"
    sha256 big_sur:        "76047bcf0396c24152d2043c2e30d036bb521936f456197a3ed42f2d1579cd41"
    sha256 x86_64_linux:   "b7048cceda6124f4485a56f642ea68a432ff32bc7bfb8938a5fad1c4f6bc05a4"
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
    system bin/"coqc", testpath/"testing.v"
  end
end
