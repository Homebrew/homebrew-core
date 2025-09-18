class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-2.4.0.tar.gz"
  sha256 "6307218d7e434fb6ffc81b9275c673d3f7f1f4884ad59b904abd205c437021a0"
  license "CECILL-B"
  revision 2
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f50db9749c2eb1e6c69d1cad4f5fc9643cf46fd676c5cc9472598d0333c2a58e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eabe13a0de7a122bcfa7ce4263041ae8adcd4409fd20daa0d65e0380d85b84cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eac1d24ea50f9cbe36b2674bf23aaa8207cb24ab173bd759c1ed5362dc3337ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31dc0aeeba701290a8d61da65d90764317c4bcc08d7416d2432704969e84b399"
    sha256 cellar: :any_skip_relocation, sonoma:        "304ba73e50826a766924001836192b8618aa0d67fb1aa12fd759a1e2ead89330"
    sha256 cellar: :any_skip_relocation, ventura:       "89364e88e0c6d66dd6ef08f90a484f014e2e04782c0341d8cc56043af26da985"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd75cdd60e778402cbdccf3014d6e376e62bfa62c89bb5bd06134620fcac0788"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "435e9c0f9df8b2115f23d7ceac83842af297a73f1f6c15bc555785d288dcd832"
  end

  depends_on "ocaml" => :build
  depends_on "ocaml-findlib" => :build
  depends_on "hierarchy-builder"
  depends_on "rocq"
  depends_on "rocq-elpi"

  def install
    ENV["OCAMLFIND_CONF"] = Formula["rocq-elpi"].libexec/"lib/findlib.conf"
    (buildpath/"Makefile.coq.local").append_lines "COQLIB=#{lib}/ocaml/coq\n"

    system "make"
    system "make", "install"
    elisp.install "ssreflect/pg-ssr.el"
  end

  test do
    (testpath/"testing.v").write <<~ROCQ
      From mathcomp Require Import ssreflect seq.

      Parameter T: Type.
      Theorem test (s1 s2: seq T): size (s1 ++ s2) = size s1 + size s2.
      Proof. by elim : s1 =>//= x s1 ->. Qed.

      Check test.
    ROCQ

    ENV["OCAMLFIND_CONF"] = Formula["rocq-elpi"].libexec/"lib/findlib.conf"
    assert_match(/\Atest\s+: forall/, shell_output("#{Formula["rocq"].bin}/rocq compile testing.v"))
  end
end
