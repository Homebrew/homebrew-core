class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-2.5.0.tar.gz"
  sha256 "3db2f4b1b7f9f5a12d3d0c4ba4e325a26a77712074200319660c0e67e25679f1"
  license "CECILL-B"
  revision 4
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03645172fd12fc8a419b3220cc5b868dbfd5ca1a8a36e9866b0a1479f37a4a18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "094a1eb55c62fd05623d5277b9b427d6f1809e458e4fd064844c12cf9b977ec7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f361bef7077775dbe45ca087dd332aec5727bb1c577549b9e373321241bfbb23"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1b7e1c3a77f020fecae846ff27843f89fb7eb3f86a52cf9c3d74790219ba80e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "562db5b63ed008ca669ffbadb7c3623ffa85a0857507302045f115222f1781d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdd53214167d5ec66265df1a429cf0d2914b01337d530147ef0cc0e5178b7613"
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
