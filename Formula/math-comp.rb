class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/mathcomp-1.13.0.tar.gz"
  sha256 "4334e915736f96032e1d4d502e70537047220af1a1c7a6740f770e45601bdab0"
  license "CECILL-B"
  revision 1
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7930a0752ce3deaa24a028cb07452e7ddcfc1ed59542a930c23a2d369f529e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b3a697a5787b530a35561599cdb22aa2c9f4df22e68c40c593b82286bd8e462"
    sha256 cellar: :any_skip_relocation, monterey:       "517e2cd5b7cc67f1812a3212975e2a168c3c670a1ef7f5590cf053d778bbf4b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "19f4688730d7ff48f03ab7486dbf8ec64f24b8b92a011b7cc20aa374dfb6a30d"
    sha256 cellar: :any_skip_relocation, catalina:       "e4ab7930f3a6f24acdaec85b79f0ff9a659ee76219853585177ed5a2e3065c53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e23441758f91573ec76ff8e61cc78a957a95f78be8b564635ecf4dcc98cb1642"
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
