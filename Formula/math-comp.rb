class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/mathcomp-1.16.0.tar.gz"
  sha256 "36fe4f5487f4685db9c6e6affa92abb47248440e6d4dfaaa01ab31df5fd4b513"
  license "CECILL-B"
  revision 2
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a1fd1938d56162b9b97a00dd6cc8708ee5adbfe0d85801a95a1a717e3867b1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cf539b3324c7f83d8a0585fdf3bde0b86526244b61e999cddac9f494cb293ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbed5c3a4175dc5c5ce81722a3c3b7171af8406f262116766846472e442e8257"
    sha256 cellar: :any_skip_relocation, ventura:        "259875d1cc25f92051ba7b1cc38b444f7e707d104330b286cd98bcd1796c2c52"
    sha256 cellar: :any_skip_relocation, monterey:       "ffe908a4d2bd6d5e8d2975726595941ce3e475f1acb46583cb57eaa5f6abe470"
    sha256 cellar: :any_skip_relocation, big_sur:        "c95b477b39c6601a2fddeab4f428c27ea53f8ed4adbe2f952d6dcefd5353909b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2feb4d254789283c3e4189d4893268d8b87a0e07f8e6260d2c0207fff2b6f2f6"
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
