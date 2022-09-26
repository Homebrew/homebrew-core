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
    sha256 arm64_monterey: "49ab12e191b51e815c80b695c207813eb17a33698d3814387cfaa92776726367"
    sha256 arm64_big_sur:  "1ff641d832c407834e85a5e518c3afe29adc8d82f9f1c4ebc69caaf91e99c033"
    sha256 monterey:       "ffdd7527e08e32012f2c49295aa45955d937ba7e97dd3bd085635f15b51463c9"
    sha256 big_sur:        "77ab0ab206936dae52fee15b2d38e457c30ac7bbf29ce0521f7b1db4e8d5b974"
    sha256 catalina:       "355dabbfa119eff9e1ff8fa10864cda98a4182ab4ade1d07d05d450ccaba4344"
    sha256 x86_64_linux:   "6a6a6986f7c285b95c13235b146fd3bc7bf85838864e253a7659a1b96d98d2c1"
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
