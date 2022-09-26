class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/mathcomp-1.15.0.tar.gz"
  sha256 "33105615c937ae1661e12e9bc00e0dbad143c317a6ab78b1a15e1d28339d2d95"
  license "CECILL-B"
  revision 1
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f78c660f2f55418d523e0500078bef8d3a47165e49eb30b947e3511e8e7442f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5fd81bb0a904238aa385b11800e5295ea15d02b6076d67c1bebcef0d9ace7fd2"
    sha256 cellar: :any_skip_relocation, monterey:       "6df9d50302667110c1f0cbaff54204639f3e695ca74eb3e109d9b5c0cbb3a3a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "0eded8904b0ced373a5102569d8d7f0f4e3b881104511922a6bb4b9c588afc0c"
    sha256 cellar: :any_skip_relocation, catalina:       "855980b233acdad3a86e7270e414e23d0837bca3553beee01b0fb920190dac37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da5053bb6656da84d711efdac11c269ca7231ee73430bb921d70f685ba7b29fa"
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
