class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/mathcomp-1.12.0.tar.gz"
  sha256 "a57b79a280e7e8527bf0d8710c1f65cde00032746b52b87be1ab12e6213c9783"
  license "CECILL-B"
  revision 4
  head "https://github.com/math-comp/math-comp.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2fb48ebd8d548d4d1559644a0c725e0bc3702d7ba95997ccef5a8a1ea1175051"
    sha256 cellar: :any_skip_relocation, big_sur:       "62826f15869cf70f3b135cbbdea8d6857435d975d7db06dbf01230a86388e1b3"
    sha256 cellar: :any_skip_relocation, catalina:      "0126d4b72e50ccb2a007b21e854118616aff7d533cc17dec31e5dd14a5a58748"
    sha256 cellar: :any_skip_relocation, mojave:        "8731904c3f814a23b74b9b1dd84f06d227909a1b159448c3937dbaa5a60d3458"
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
