class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/mathcomp-1.14.0.tar.gz"
  sha256 "d259cc95a2f8f74c6aa5f3883858c9b79c6e87f769bde9a415115fa4876ebb31"
  license "CECILL-B"
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faf76c24a23aef9a04311eacddae1e1a660f0fa68b253e2905fc3cc3b50c466f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06140587c18f4ec70608f0aba5650bc7be7a7d3676a5a0bd25eab2ba75db1c3f"
    sha256 cellar: :any_skip_relocation, monterey:       "b2fd80ea132bf150e55c1cf16ee881a685b3a4600afbc4522949299959b17606"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae3295d93bc735374ac5792c22cd2f9429a58dad315c7cfac90c050af052d361"
    sha256 cellar: :any_skip_relocation, catalina:       "4add343fe983aab123338059a5824ba9694c7249192e7a46c7df705835a55c0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5cabadd16e768783ce263c1df791aa5d82774634b345351d58d6392cf00998b"
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
