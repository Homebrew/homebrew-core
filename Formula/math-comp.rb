class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/mathcomp-1.16.0.tar.gz"
  sha256 "36fe4f5487f4685db9c6e6affa92abb47248440e6d4dfaaa01ab31df5fd4b513"
  license "CECILL-B"
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf4aed12721c6a09c32fef815d7b07efde4e84a244d53bc862da14767bee78ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62e69d21744ae697f02604d17accba13a79f90d4314c85f75fbbee96ce569b95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e4f355ff980f3e5fec5634e67388617ad79662b1a2d3aebc6552b94e101482b"
    sha256 cellar: :any_skip_relocation, monterey:       "313a1cdc207d173403d33ea1064b9f23f395e2289caff0f6a16c31b90eb2f3a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "f430258427aae631256713abc61b1164f0398e23915c983679b4fd2cf2389847"
    sha256 cellar: :any_skip_relocation, catalina:       "c871b9842437ae98f55064797b2f7df00924d8bd7816da7e1e58c45c96d38c42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36028b70e62730c19f6afa4bbdf9873fc65dae8323ea968b7d1e63bd2889dfe4"
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
