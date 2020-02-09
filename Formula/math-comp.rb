class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/mathcomp-1.10.0.tar.gz"
  sha256 "3f8a88417f3456da05e2755ea0510c1bd3fd13b13c41e62fbaa3de06be040166"
  revision 2
  head "https://github.com/math-comp/math-comp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a5e3378d663d69eae75fe6b59a0531a00d88e474f8f7f5a3e255cac76b14e63" => :catalina
    sha256 "127f7df93e47816106aa637d9ee65190d23c3d6829efa648e03bb4e5fda8df8d" => :mojave
    sha256 "6a5e3378d663d69eae75fe6b59a0531a00d88e474f8f7f5a3e255cac76b14e63" => :high_sierra
  end

  depends_on "ocaml" => :build
  depends_on "coq"

  def install
    coqlib = "#{lib}/coq/"

    (buildpath/"mathcomp/Makefile.coq.local").write <<~EOS
      COQLIB=#{coqlib}
    EOS

    cd "mathcomp" do
      system "make", "Makefile.coq"
      system "make", "-f", "Makefile.coq", "MAKEFLAGS=#{ENV["MAKEFLAGS"]}"
      system "make", "install", "MAKEFLAGS=#{ENV["MAKEFLAGS"]}"

      elisp.install "ssreflect/pg-ssr.el"
    end

    doc.install Dir["docs/*"]
  end

  test do
    (testpath/"testing.v").write <<~EOS
      From mathcomp Require Import ssreflect seq.

      Parameter T: Type.
      Theorem test (s1 s2: seq T): size (s1 ++ s2) = size s1 + size s2.
      Proof. by elim : s1 =>//= x s1 ->. Qed.

      Check test.
    EOS

    coqc = Formula["coq"].opt_bin/"coqc"
    cmd = "#{coqc} -R #{lib}/coq/user-contrib/mathcomp mathcomp testing.v"
    assert_match /\Atest\s+: forall/, shell_output(cmd)
  end
end
