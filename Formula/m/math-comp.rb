class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-1.19.0.tar.gz"
  sha256 "786db902d904347f2108ffceae15ba29037ff8e63a6c58b87928f08671456394"
  license "CECILL-B"
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf9910e17e82f0da672a0ab92f12291f36fd3dc39b43321f34d37017fbdca828"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59f6e0cae487a24cba303a7e513d8ebba1d639fe34013d935206f66cc86616c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "832f1814f6ecb2c9477e0551fa184e711d61dd6e4165218ca205fb190c8109a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "d48a062a31d521a6f9bbc821b101cf7c194116bc168d3e4d99f0487842b3304a"
    sha256 cellar: :any_skip_relocation, ventura:        "d6528d8f8c3b631ebe20afaf72c33bd879abde7bef5f988237a0bd90c21c7f8c"
    sha256 cellar: :any_skip_relocation, monterey:       "6849eebc16e35a589a9ef05988c858faaf2d3a35217e9a1b219f3d8f2605e630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03d1f37344e58080999eb20598ad651910a325d998821b254792ec204383b129"
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
