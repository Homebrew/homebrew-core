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
    sha256 arm64_monterey: "d7f23fbb682540128e971f470d84655daae035fecf0275dc99b718a22df7a4c0"
    sha256 arm64_big_sur:  "907068472a08346d4d8b6f88192d110d91a9f36c6ef4fae993cf38c1aa09fe5e"
    sha256 monterey:       "c0443d41431b5f165a499410a5907ddd66158836e25cea0471a22f3311d8540e"
    sha256 big_sur:        "cf833fba7b8fca257432c406feaba3c0b1074c28d9db67b5a47f7d79d8af61ce"
    sha256 catalina:       "7c7d340763b9efc93c7e4e6564bf10ac06456a9d6b910fa1c337736c68c713e8"
    sha256 x86_64_linux:   "7b86c2275b467edef96d619c0964f955c5c07ae78300609b3b8c061cd952909e"
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
