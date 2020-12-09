class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/mathcomp-1.12.0.tar.gz"
  sha256 "a57b79a280e7e8527bf0d8710c1f65cde00032746b52b87be1ab12e6213c9783"
  license "CECILL-B"
  revision 1
  head "https://github.com/math-comp/math-comp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "37468c0f985d7306b040661504f238bbece0f7c5a9ba2cff67a2b3ec5bfc734a" => :big_sur
    sha256 "32aa060170d60dbef2f63b9e9c0ac0141e1ffab9862280023512665dd78092fc" => :catalina
    sha256 "17ac51a7c7d32370903679049a0285762037c9728e74a27bdc7d1008ec84d27b" => :mojave
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
