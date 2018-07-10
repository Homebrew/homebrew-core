class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/mathcomp-1.7.0.tar.gz"
  sha256 "69c01e99aad618fa9a0bb4a19af00827c505b8205816eb590e51abca49f4ef17"
  revision 2
  head "https://github.com/math-comp/math-comp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1a765625508585ca3768544628b9a71c9c92e8509f3e8a1019ee56c5691d0a0" => :high_sierra
    sha256 "121eaa1a5669511683adf613241dcf2460b75366afb52b3c7f4844b16a10ac10" => :sierra
    sha256 "6634ee5946a464872dec8a580c4dfcf7431af864e4629d333ad62298f4ef8fd9" => :el_capitan
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
    assert_match /\Atest\s+: forall/, shell_output(cmd)
  end
end
