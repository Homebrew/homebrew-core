class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-2.5.0.tar.gz"
  sha256 "3db2f4b1b7f9f5a12d3d0c4ba4e325a26a77712074200319660c0e67e25679f1"
  license "CECILL-B"
  revision 3
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5320ff41473750288cf0db83fad9d47d6f7abdf049e06c5c3d8b3e842cc78c4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96651e338894cee2d72ac9e81ca04d197563aed19cf0db269fd54b3658f7e048"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c73b30e611aa6128665e31bf5acdbb89f0dcae74ac9cd3d5c11b8180c2faec4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "71ef8662ce5d2bd912b828987b5dd0b0b9558f39664fd31ce2133d7a754f4002"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7800bbb07c16c85bab27349b72d65f05ea2a59adffbce0e959fa29c3652f7a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54480221ea4d58c13d3bc6a3fe133974f2bdf40183f7da0fd47c2da6c5631bda"
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
