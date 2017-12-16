class Camlp5TransitionalModeRequirement < Requirement
  fatal true

  satisfy(:build_env => false) { !Tab.for_name("camlp5").with?("strict") }

  def message; <<~EOS
    camlp5 must be compiled in transitional mode (instead of --strict mode):
      brew install camlp5
    EOS
  end
end

class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/archive/V8.7.1.tar.gz"
  sha256 "d381b38522cee0e73804ee3a763648f602eda942312c18d333f9567c56dbfd03"
  head "https://github.com/coq/coq.git"

  bottle do
    sha256 "73602b7d0b5b29d1e2bf33819e68e89f45dff372448ad6ec2f37d919e188a9f3" => :high_sierra
    sha256 "12dabebd2bc8fa9bd5f5e96ab5b525c6b692efd75fadd79d7bda91ce0ccd911e" => :sierra
    sha256 "6043afb260ab56cc3b64b4998b7f609c4143b30c43d5205f64aa7e6d41724fe9" => :el_capitan
  end

  depends_on "ocaml-findlib" => :build
  depends_on Camlp5TransitionalModeRequirement
  depends_on "camlp5"
  depends_on "ocaml"
  depends_on "ocaml-num"

  def install
    system "./configure", "-prefix", prefix,
                          "-mandir", man,
                          "-emacslib", elisp,
                          "-coqdocdir", "#{pkgshare}/latex",
                          "-coqide", "no",
                          "-with-doc", "no"
    system "make", "world"
    ENV.deparallelize { system "make", "install" }
  end

  test do
    (testpath/"testing.v").write <<~EOS
      Require Coq.omega.Omega.
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

      Import Coq.omega.Omega.
      Import Coq.ZArith.ZArith.
      Open Scope Z.
      Lemma add_O_r_Z : forall (n: Z), n + 0 = n.
      Proof.
      intros; omega.
      Qed.
    EOS
    system("#{bin}/coqc", "#{testpath}/testing.v")
  end
end
