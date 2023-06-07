class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/mathcomp-1.17.0.tar.gz"
  sha256 "1779bcdac5d23d90997627364a5943ef4883c6eb54d67ddbb1dfbe6b7795a188"
  license "CECILL-B"
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68de27822d84b9d5fa23b61ce280873cb8f65f7008616f1e4da31f2ad0f5b8da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "681a7a76afc6fd1ff8a893c8ec1f2f0db74371043ff6092912d8f5089a67e59e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77842dae981a926fbd83700a69823334ba15ec2ef6880499e44ee6dc895a83fe"
    sha256 cellar: :any_skip_relocation, ventura:        "3f19f012f400da65bcc7377063486efabc8d9bd4342c8d0652a9fd74f830420d"
    sha256 cellar: :any_skip_relocation, monterey:       "1252a413c869db92405fe787e324d0943aeb498c143ff168c6fbca4b3e4a91b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5d4cae57450c921d23c7b1bf401437b129af605442ebf82a76b685b3c4f0217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80d712cb4d8fb1dd868e406c89c8e71d2bd57e374b50b553c53a47c3037fb54c"
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
