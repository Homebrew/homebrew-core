class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/mathcomp-1.16.0.tar.gz"
  sha256 "36fe4f5487f4685db9c6e6affa92abb47248440e6d4dfaaa01ab31df5fd4b513"
  license "CECILL-B"
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4272e83270c924aac5a6bcc1a38841f5d5a5cff4c3a0641f5e61d838ca960c22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5659cc97dddf3e8af48867d3d06aa766d8ca193a012bdb72aa4de64e9e91438"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d43c52805708d27f4353896f9811d8522381550f7d3f81b18a444556f0591ea"
    sha256 cellar: :any_skip_relocation, ventura:        "32c73e300d77346abacddc276aaa6302fd34b3fff4d262faa2a88c7bdcbfec64"
    sha256 cellar: :any_skip_relocation, monterey:       "4719a1471f1c3b7b78104762c5ede7b03ea835cf26596766d184e352cdbffd2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9effd0a933673ee1f659b6622c76f583b5b7258bbc1050d7ba03adb43d5a1fd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ebf0438b7e5d58e69cdc285fe1368e894d2e99bd09e2f30ef270faa77308e6f"
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
