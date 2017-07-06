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
  url "https://coq.inria.fr/distrib/8.6.1/files/coq-8.6.1.tar.gz"
  sha256 "32f8aa92853483dec18030def9f0857a708fee56cf4287e39c9a260f08138f9d"
  head "git://scm.gforge.inria.fr/coq/coq.git", :branch => "trunk"

  bottle do
    sha256 "2de7aac122e38d25d09f85e367c5f7541ef9db6588bc4dd2fc05d5ba740eda9e" => :sierra
    sha256 "a6db94a34cc5d56f9b094b6b28104be5a86f5f1052c0abeb497f5f58a470acff" => :el_capitan
    sha256 "e9c282b008dd5030895f16e7fc68249eca3c3eaecaa4c1c7fb258670242374de" => :yosemite
  end

  depends_on "opam" => :build
  depends_on Camlp5TransitionalModeRequirement
  depends_on "camlp5"
  depends_on "ocaml"

  def install
    ENV["OPAMYES"] = "1"
    ENV["OPAMROOT"] = Pathname.pwd/"opamroot"
    (Pathname.pwd/"opamroot").mkpath
    system "opam", "init", "--no-setup"
    system "opam", "install", "ocamlfind"

    system "opam", "config", "exec", "--",
           "./configure", "-prefix", prefix,
                          "-mandir", man,
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
