class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/archive/V8.17.1.tar.gz"
  sha256 "724667de65825359081b747d41fdbead0620d43b57aa8377a27acd4b072585e6"
  license "LGPL-2.1-only"
  head "https://github.com/coq/coq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "17428d897cd59b5ad624055c3de93ad2e40781ccc99db16333a71aaad58a3386"
    sha256 arm64_monterey: "16f1d9f1950219e0af6e4e06c28813908367ed23bff7ff1c3c4310c8afbaf653"
    sha256 arm64_big_sur:  "afc36bee0d091cc4902e1553daee20767dd4b4585ab7b54c8d34adf602616270"
    sha256 ventura:        "d78a6b69c915bf1529eb04aae3b2582a9226102abf02182eb12966a59f22e8de"
    sha256 monterey:       "0e46aa5d4bc792918c9532644c16f40f7c67c351bb12731afb60b93b17d61591"
    sha256 big_sur:        "ebc637b55147ceed8574602c71575281b7b12246859dd61eb0fdf1c71693cc5d"
    sha256 x86_64_linux:   "19fb510814e223b19f28e0c2aa67c4b9add7fdbc65772ad7b8a41214685b9acd"
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
    system "dune", "build", "-p", "coq-core,coq-stdlib,coqide-server,coq"
    system "dune", "install", "--prefix=#{prefix}",
                              "--mandir=#{man}",
                              "coq-core",
                              "coq-stdlib",
                              "coqide-server",
                              "coq"
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
