class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-2.5.0.tar.gz"
  sha256 "3db2f4b1b7f9f5a12d3d0c4ba4e325a26a77712074200319660c0e67e25679f1"
  license "CECILL-B"
  revision 5
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8357b67379784056d5606adcbb012c24a6972894967835beaeeb47e7aafc61fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f16379606e97bd95354c8524afd7dbbff369f957fe0857b0a400f89f27cc70b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d7ef69b46fd63e86fe447dfcbde421f840ed79d84a893c50637951ae6f187fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba925b81bb93e4b12a4dcc293ba25c87fb7c186f250b17b7a9822f83aa1ce2f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b40dc7f611788a598d1e777b4cc4ca8f3928ffb5360fa7af39f03d8394700afd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dbaf59ff86542eb7f377baac236ea3bec61cf86685714b99d4aee3facc86127"
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
