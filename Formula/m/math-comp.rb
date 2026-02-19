class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-2.5.0.tar.gz"
  sha256 "3db2f4b1b7f9f5a12d3d0c4ba4e325a26a77712074200319660c0e67e25679f1"
  license "CECILL-B"
  revision 2
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5ee5a738a5a24c99e4bfec3fc485c8830c1f9b978c1205bb4ad751bb0955fca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c016ae4babbd2bfe11c2a20d700be112398ab30ac8deeabbc94dd66263d10338"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10ac32097f9eb070e1e15f922cb9c6f0b0a6eb8aae86d3c5100c54ef2f950544"
    sha256 cellar: :any_skip_relocation, sonoma:        "02b0d0a53501f6b367d257c12a57ee3b3d2afbbb014f233f5a4a1b6928ac2371"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cd91382f3fe398c94fa725099c2a24fa8ca2b71f76edc3c65c14b4070cf7dcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "991be39002d9e7884e25b2aafdf1d814bf25c8912abad59b5793a7b57a4432c9"
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
