class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/mathcomp-1.13.0.tar.gz"
  sha256 "4334e915736f96032e1d4d502e70537047220af1a1c7a6740f770e45601bdab0"
  license "CECILL-B"
  head "https://github.com/math-comp/math-comp.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68955d63313cc612502041601eba758a3c0210af6d277eb69a96ed54f0af2ac8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edaea0ef9b4e2243853ffb948354c01d196eadd1af1b505b775a52ae6e6419b4"
    sha256 cellar: :any_skip_relocation, monterey:       "01ef7db2ac990cd1f4aa80fbe2f41934cf515b4e6e2a445d87d02fc5fb7b9864"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ead946a08d833689a5e6aa8ae7d4ba734b3881e10e702f852fbfc17af700c49"
    sha256 cellar: :any_skip_relocation, catalina:       "62c03d5f102c44aec11ddeed1eef155a9423eacaf8e8d551055ef98e16a47d1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04ae3c0340aa0824046ab7f0ba69aec3e26b979968e97848815af411b3dfaaf0"
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
