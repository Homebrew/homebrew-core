class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/archive/V8.14.0.tar.gz"
  sha256 "b1501d686c21836302191ae30f610cca57fb309214c126518ca009363ad2cd3c"
  license "LGPL-2.1-only"
  head "https://github.com/coq/coq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "54894e4e79d0350a885179db6a4e27f0b999300bfaeb85559eb0a21d077d3ed9"
    sha256 arm64_big_sur:  "c6cca2fc5b3e5bef2a8e41dd0be406f194d851488f203e8e28b13ee50cfa3de0"
    sha256 monterey:       "9165f4e29ed7e25b00498f71cb608b9e74cf1dd64df5fcd403d6cf2c35b11cf5"
    sha256 big_sur:        "713249fb2cd2bd966aee2f72650a903cacf73755827fe18145048558d7b046df"
    sha256 catalina:       "389f742cb25060e9a1ccfe95038a0894861d6d44dfcf5041baef6e68337cf383"
    sha256 mojave:         "122e19363864981f2c48354282cb5ecfad5ef2a729b070666e9df134220130c4"
    sha256 x86_64_linux:   "f7638795e1099deb2573fb402f0526bbef723e362f04f6ae6626c26dce8060dd"
  end

  depends_on "dune" => :build
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
