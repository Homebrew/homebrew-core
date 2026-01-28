class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-2.5.0.tar.gz"
  sha256 "3db2f4b1b7f9f5a12d3d0c4ba4e325a26a77712074200319660c0e67e25679f1"
  license "CECILL-B"
  revision 1
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f85029cc515cfcae9bc2abd85dc46c9a8d2d47eea0c00520fa68f56fed579555"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7957c6d978bc6fc301a7858c8b45a6ab6962840f9da7fb062585e642bb85c95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "131a3cd1045e1701a89074666cc60ef1290e3d078472101750a05042fc142f93"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd9267940b4213d4cdd9eceefac4c8f69287c214accd01b6999656db51f5eed8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72021e15fa59164b30fe7750a3f03e05f71a6231a4b65e1832305d91ed412254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b03fae6ecac6bc1a5fc44f5a516f9c9abbb3c322296ca90abbaa222006464370"
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
