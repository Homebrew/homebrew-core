class Camlp5TransitionalModeRequirement < Requirement
  fatal true

  satisfy(:build_env => false) { !Tab.for_name("camlp5").with?("strict") }

  def message; <<-EOS.undent
    camlp5 must be compiled in transitional mode (instead of --strict mode):
      brew install camlp5
    EOS
  end
end

class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://coq.inria.fr/distrib/8.5pl2/files/coq-8.5pl2.tar.gz"
  version "8.5pl2"
  sha256 "83239d1251bf6c54a9ca5045d738e469019b93ca601756bf982aab0654e4de73"
  head "git://scm.gforge.inria.fr/coq/coq.git", :branch => "trunk"

  bottle do
    sha256 "774e14c3f3755fe94d20fc3c410b54239f3365b1e3961ec7a3066e59c87a3666" => :sierra
    sha256 "6bca59c08a4ec3b0633621332d9e66eb252c652d3efbce51f039ff8e6b7fe28f" => :el_capitan
    sha256 "a61a407c55cde0cd9a68e2995af1af227b5dfc66060438254b3f4d76baa4dc1d" => :yosemite
    sha256 "12444450f927ce6ebe0ff4dbbde42530edc57ee2e3a1baa5748cd987bf9750d8" => :mavericks
  end

  depends_on Camlp5TransitionalModeRequirement
  depends_on "camlp5"
  depends_on "ocaml"

  def install
    camlp5_lib = Formula["camlp5"].opt_lib/"ocaml/camlp5"
    system "./configure", "-prefix", prefix,
                          "-mandir", man,
                          "-camlp5dir", camlp5_lib,
                          "-emacslib", elisp,
                          "-coqdocdir", "#{pkgshare}/latex",
                          "-coqide", "no",
                          "-with-doc", "no"
    system "make", "world"
    ENV.deparallelize { system "make", "install" }
  end

  test do
    (testpath/"testing.v").write <<-EOS.undent
      Inductive nat : Set :=
      | O : nat
      | S : nat -> nat.
      Fixpoint add (n m: nat) : nat :=
        match n with
        | O => m
        | S n' => S (add n' m)
        end.
      Lemma add_O_r : forall (n: nat), add n O = n.
      intros n; induction n; simpl; auto; rewrite IHn; auto.
      Qed.
    EOS
    system("#{bin}/coqc", "#{testpath}/testing.v")
  end
end
