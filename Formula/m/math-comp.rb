class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-1.19.0.tar.gz"
  sha256 "786db902d904347f2108ffceae15ba29037ff8e63a6c58b87928f08671456394"
  license "CECILL-B"
  revision 2
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ea1b572027d6051e36a26a2a813deaf63fbcff5dd65dc0bf38842649ad3a5fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a82eb21533f651ee962e0d64c9b9574c6fcd0c3ce6a91767d1a734b1f483f425"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59ceb23e02aa6142e9b1adbd135f46afca15f2852596d2b2089e75ec11cd6888"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb7f57a80f97d5d4514c126f6fb659681c46b789f0fcf83a3893814db91e2db1"
    sha256 cellar: :any_skip_relocation, ventura:        "de4028a41747143cdd6a113681e178beef7df9c0e5cb674fbeac82cb27359bc4"
    sha256 cellar: :any_skip_relocation, monterey:       "475dcb71b57f8c7ec671a083d39162e7e6a3673f30533814b8b2d3f9dd74236f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b0c39d34525e702e21d0b9e43a9722c61c564f658d7ffafc468c397fc79738a"
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
