class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/mathcomp-1.14.0.tar.gz"
  sha256 "d259cc95a2f8f74c6aa5f3883858c9b79c6e87f769bde9a415115fa4876ebb31"
  license "CECILL-B"
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faf8e4e316527e1589ddece4c263b64ba60f12f92e27726b1d9658bd95f9971b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b188eb697049614a810781431ded0f7d35327c5cc20f5a92a5bd785c710244d"
    sha256 cellar: :any_skip_relocation, monterey:       "22601f9f8726dc6ceee9e84bb34b54667e81f89a39f81f9a3164595c2ba8bab8"
    sha256 cellar: :any_skip_relocation, big_sur:        "e68042b7cf46e9d1714117212ddb647a02e8aee9d576e7576d996274fdc4e3e8"
    sha256 cellar: :any_skip_relocation, catalina:       "858e8b26f67f0cf77d28336b35f083dcfb5320cdd8b81b04a2e3ab084d5fb7f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec82091ef0ff25dfe07e6d4b5774798d8f511b210d3eeb4f6f2b07fbe5b17dd4"
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
