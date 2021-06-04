class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/mathcomp-1.12.0.tar.gz"
  sha256 "a57b79a280e7e8527bf0d8710c1f65cde00032746b52b87be1ab12e6213c9783"
  license "CECILL-B"
  revision 5
  head "https://github.com/math-comp/math-comp.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fba9e5fff8717ec206afc69fae6ee4af285625e381974e56367dd2f3a9d4fc1c"
    sha256 cellar: :any_skip_relocation, big_sur:       "3e2692620ca6d753e7fe6f9122435cebdcf84f925fd227e058794195d8d80e61"
    sha256 cellar: :any_skip_relocation, catalina:      "b750bc8c02d530d9ff1648f58e8c517e9c28117ca3834f14d78cf703785dc75c"
    sha256 cellar: :any_skip_relocation, mojave:        "ea939ecf266cef2f643b2ecd72592a9c75b5baa943f44a75e30c5aa961a1b751"
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
    assert_match(/\Atest\s+: forall/, shell_output(cmd))
  end
end
