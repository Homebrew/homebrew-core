class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/archive/V8.15.0.tar.gz"
  sha256 "73466e61f229b23b4daffdd964be72bd7a110963b9d84bd4a86bb05c5dc19ef3"
  license "LGPL-2.1-only"
  head "https://github.com/coq/coq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "94d901ca4675f97322ae04f3474bb0345673d8925c30128c170c09ef97c9904d"
    sha256 arm64_big_sur:  "f58c9dd0cf172093fbc08189ed89885c0eb492685cf8d852798366414733eb05"
    sha256 monterey:       "b8b12628eb6693abc60a80e02b312429d01d354569338f7641e54238b7abf754"
    sha256 big_sur:        "40514554b814a1d95d128baf4d2fffb54b01ec51821dc3cb228a4332a79ea6f5"
    sha256 catalina:       "8b9006e565578633129b4eba9ec6bc752456a70748ad9358beefb7c4d389c7fb"
    sha256 x86_64_linux:   "01ac370c205cc12a7b1370b476013e085d418a2ba4b420d1f8f7d21ae52d4953"
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
                          "-docdir", "#{pkgshare}/latex",
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
