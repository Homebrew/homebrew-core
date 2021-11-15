class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/mathcomp-1.13.0.tar.gz"
  sha256 "4334e915736f96032e1d4d502e70537047220af1a1c7a6740f770e45601bdab0"
  license "CECILL-B"
  head "https://github.com/math-comp/math-comp.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75afab708aff5ad90fff18656350a543bb650fac9bb34ecbeeedd01c65756837"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e53cbdeec509efb71212744022b7fbd856953a432f72a470b3ce3998661fffe9"
    sha256 cellar: :any_skip_relocation, monterey:       "1983bcef8dd4aa8ff459469068a2ba0c72a32fbc69bb3d24aed63d66cc2e0feb"
    sha256 cellar: :any_skip_relocation, big_sur:        "12f69823e237858152983c091233fb049f4217af965d4bd2c7714e8acfb1651b"
    sha256 cellar: :any_skip_relocation, catalina:       "ccab739e4ad1a508e393e328ea89cd1076ffa9e28e66d618dda52cf6ec0e20b5"
    sha256 cellar: :any_skip_relocation, mojave:         "ab4cc68722efabe217ff311e1918a04369f4456c729e9e7484f8110b495bd650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91e7990285a6cd02a0783edc360e8367cb6bf286eecce76c049707ffb7a41ae7"
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
