class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/releases/download/V8.19.1/coq-8.19.1.tar.gz"
  sha256 "1e535ed924234f18394efce94b12d9247a67e8af29241eb79615804160f21674"
  license "LGPL-2.1-only"
  head "https://github.com/coq/coq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "a93180d61587f2b1de891d1e44209e3a6b4c3309358237a5c8ee51512b37e1ee"
    sha256 arm64_ventura:  "64d2843a331221922ecb451d7fcf9e9452e11d6cafc989f7a72f5ddd5fb95731"
    sha256 arm64_monterey: "dffe71678cacfc2a3b632e75eee1d5b1c7984bf9ddc2a4afe4e9df454709e782"
    sha256 sonoma:         "890818aa86192050cb0aef368a339653988bc473b526b9610b34487bac0668ff"
    sha256 ventura:        "d6285f8393333c3e1b83f7948f25cbd4a939d0011d9f1783fb83602ddf98fda9"
    sha256 monterey:       "d417eff81ca483b9832493dba3f9e6653e5eea1b9fcffe1c645725edd2db48f3"
    sha256 x86_64_linux:   "b9979855e4fe5fbca8ad5927c0fd06e041223ae252e148cf98e042106dd23708"
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
                          "-libdir", HOMEBREW_PREFIX/"lib/ocaml/coq",
                          "-docdir", pkgshare/"latex"
    system "make", "dunestrap"
    system "dune", "build", "-p", "coq-core,coq-stdlib,coqide-server,coq"
    system "dune", "install", "--prefix=#{prefix}",
                              "--mandir=#{man}",
                              "--libdir=#{lib}/ocaml",
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
    # test ability to find plugin files
    output = shell_output("#{Formula["ocaml-findlib"].bin}/ocamlfind query coq-core.plugins.ltac")
    assert_equal "#{HOMEBREW_PREFIX}/lib/ocaml/coq-core/plugins/ltac", output.chomp
  end
end
