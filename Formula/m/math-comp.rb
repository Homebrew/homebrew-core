class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-2.5.0.tar.gz"
  sha256 "3db2f4b1b7f9f5a12d3d0c4ba4e325a26a77712074200319660c0e67e25679f1"
  license "CECILL-B"
  revision 6
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "070ac5ac0f8b3827477f6d548a2cd3682987121d60b1f7ef80e20aa37b290142"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "563d30171d38f0c2a15943a314dae11756ba6c30d2f4b079243ee8e085c1ce02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "616c6ef475371ef7b16141a16497adbea19501bc16dd598d6f3b535f03ef061c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ffcdaac2ee812efec7b405100167102277f4c8d33b7cfe9d37b26c0d052e1ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8beb6034e23c053ac6d09504bcc856f8433d0e76855de0fbe42974771a50aa29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00273bdbefa9bb56b682885d83e942f88bf12c65aa50cb18e532fe33bca9af55"
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
