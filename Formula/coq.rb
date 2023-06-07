class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/archive/V8.17.0.tar.gz"
  sha256 "712890e4c071422b0c414f260a35c5cb504f621be8cd2a2f0edfe6ef7106a1af"
  license "LGPL-2.1-only"
  revision 1
  head "https://github.com/coq/coq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "008699456159b5a2aaa2ada32ce99e76036e6274217874d5d3ac85e3b686fed6"
    sha256 arm64_monterey: "63b89cf96a2210f6dc498a8af41910e765270f7de01b4e734a73c2fc562626b4"
    sha256 arm64_big_sur:  "34a66210a42dee8c70b371a362028232f57ab78b8b1e41d9b05b61d45b9916cc"
    sha256 ventura:        "409829c3d07dae2378e54e33efb175e8582b1e3c034cff0968ac9eca0dc829a3"
    sha256 monterey:       "9d16f8ee02778a71241be1a897af50d5abaa9c5c05705387c92cb5954739a9ab"
    sha256 big_sur:        "e6379d0240df1e9bda2f68ce60bab72fe63e49099cb2f1fbb4c772503949405f"
    sha256 x86_64_linux:   "85202a5fb75b2942e13b1b5d3537e1bfa1e86169e00ef0b68f56c0070e78dfed"
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
