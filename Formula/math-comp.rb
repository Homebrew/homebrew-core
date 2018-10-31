class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/mathcomp-1.7.0.tar.gz"
  sha256 "69c01e99aad618fa9a0bb4a19af00827c505b8205816eb590e51abca49f4ef17"
  revision 3
  head "https://github.com/math-comp/math-comp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b0e8def9d54704213388b94af187909c2d55f63c6ca8ff6185180d30193197e" => :mojave
    sha256 "88e40a31f5283eb0294b1aa8a9eec3d65dd6bdf1063b8430db6bd88130d85ec6" => :high_sierra
    sha256 "3549c73d20721800376ef55f291ec4ed02c7168832bf096683d8301336aa387a" => :sierra
    sha256 "50c23dadbf291c8c82af2a2ae9a109dc4266d37e985bf1b90d766e518fa776ad" => :el_capitan
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
