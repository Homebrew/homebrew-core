class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-1.19.0.tar.gz"
  sha256 "786db902d904347f2108ffceae15ba29037ff8e63a6c58b87928f08671456394"
  license "CECILL-B"
  revision 1
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1bf3c089bd6db5721d00d0ff1ea5c888b837e3153d4917d848e7048b27f669b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bdbba383d4d3c4fa96070a59b84355999fd4e98b5fcc8b5a847628d20fbcd85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a218e609f98c6949df5e296183b08f5157be4f7444c90330bf33f64bb1f9809"
    sha256 cellar: :any_skip_relocation, sonoma:         "b548204f8d93926412b8445548827182321b17bdcaf7c302d93921163100514b"
    sha256 cellar: :any_skip_relocation, ventura:        "438e0ad6722ad2dcb9d771dff63382f6f7c756344bd982a87c0a7030709bf161"
    sha256 cellar: :any_skip_relocation, monterey:       "e2f2068e7be83972c816b92cf5a4f96c9f2de1002f6eb942f11afa0b230aa2e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89051de2d2e6a58d76808d76bbe10e1e069de6a0dedee5a5b0b894096e0e774a"
  end

  depends_on "ocaml" => :build
  depends_on "ocaml-findlib" => :build
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
