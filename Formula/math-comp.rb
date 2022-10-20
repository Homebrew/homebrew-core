class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/mathcomp-1.15.0.tar.gz"
  sha256 "33105615c937ae1661e12e9bc00e0dbad143c317a6ab78b1a15e1d28339d2d95"
  license "CECILL-B"
  revision 1
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbfa024d8ffe1f14dc3e4b3f7a1bcbc2d91ba326a08fbb9510c8d060b6d1ef4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e90767d1695d1e2e1863dd330a2b44cfb4074c736dda0e9205b53644f689784"
    sha256 cellar: :any_skip_relocation, monterey:       "b5a78ef74be2af9f88013c830361f48dede0a7c8ff7035d078c72535cd7611d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f083159bb567a2201985c47ed2b8259fe68518c87a16c89e4dece9bc1513433"
    sha256 cellar: :any_skip_relocation, catalina:       "8c5adbfeca83d1c9fefccdf8eb68ded61d36218cfc1d006bd3a1b415027bf897"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad11578bca9301a269218257d9e98c00c3a7de5e42a33df4212e8f861afcefd4"
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
