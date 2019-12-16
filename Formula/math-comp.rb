class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/mathcomp-1.10.0.tar.gz"
  sha256 "3f8a88417f3456da05e2755ea0510c1bd3fd13b13c41e62fbaa3de06be040166"
  revision 1
  head "https://github.com/math-comp/math-comp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6c01868fcd5a0dcd8ec7084fbf18a8dd6a689bc91c5f9a040438bee9ca1d56a" => :catalina
    sha256 "c6c01868fcd5a0dcd8ec7084fbf18a8dd6a689bc91c5f9a040438bee9ca1d56a" => :mojave
    sha256 "b4b9e5f305cf1284df98570fcab6d16bc2bd6ac5ae73abf8497a4588f51a478d" => :high_sierra
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
