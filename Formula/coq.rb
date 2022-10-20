class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/archive/V8.16.0.tar.gz"
  sha256 "36577b55f4a4b1c64682c387de7abea932d0fd42fc0cd5406927dca344f53587"
  license "LGPL-2.1-only"
  head "https://github.com/coq/coq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "6b693d14144d92d46932724843c89083762a83b1e352b51bcbf1311b4d2de84d"
    sha256 arm64_big_sur:  "730ea0c2e9a1d3bcedd772c7ec355446996bca621e8a168c46616c17e4306c72"
    sha256 monterey:       "9775ac5bb1131df82502645adc20cbb4874e15f7db15ad1e16334cd7419e6ca0"
    sha256 big_sur:        "f3a2849971a9c26e46ba79f360cb65df0fe636667d99fac55581c8acca421cf2"
    sha256 catalina:       "3a35b8dedec20d3bf2f1332d9615d0496bc2ffae8b843579c0ebeb28e778100a"
    sha256 x86_64_linux:   "4016e4a6373e65172531419bc7a406dfc44a5186840f234f5fc94f5f5b4d62fe"
  end

  depends_on "dune" => :build
  depends_on "ocaml-findlib" => :build
  depends_on "gmp"
  depends_on "ocaml"
  depends_on "ocaml-zarith"

  uses_from_macos "m4" => :build
  uses_from_macos "unzip" => :build

  def install
    ENV.prepend_path "OCAMLPATH", Formula["ocaml-zarith"].opt_lib/"ocaml"
    ENV.prepend_path "OCAMLPATH", Formula["ocaml-findlib"].opt_lib/"ocaml"
    system "./configure", "-prefix", prefix,
                          "-mandir", man,
                          "-docdir", pkgshare/"latex",
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
    system bin/"coqc", testpath/"testing.v"
  end
end
