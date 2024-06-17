class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-1.19.0.tar.gz"
  sha256 "786db902d904347f2108ffceae15ba29037ff8e63a6c58b87928f08671456394"
  license "CECILL-B"
  revision 4
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "101b9ee1de7cb683dcab419898761801fff26e05b39c4cbf8ed90bb1712bb93d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "971e889f7ba3e46dcf5b68d11e953dba476d77f45b6da3ed221b0a4fc32628da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbe8f8f500509da594418f53ed0d136ba47893b2b77483b268262165973dfdbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ea18fbc62ce10f78a80aea3835823aad84eb9234ac664dec67c7c70ecad1aa8"
    sha256 cellar: :any_skip_relocation, ventura:        "f502337a16acddd7dba1eca79c23fd78d2a69060df73ef6df8456b36bfc92f3d"
    sha256 cellar: :any_skip_relocation, monterey:       "ff2cf377f1ff18a2258d2fbac3d874e3d032f5d3640d33b7166f2781c165919a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fb1809575a187adaaca6c91b33eff08b3e29676e9966072925c9c0aa78d56cf"
  end

  depends_on "ocaml" => :build
  depends_on "ocaml-findlib" => :build
  depends_on "coq"

  def install
    # Work around for https://github.com/Homebrew/homebrew-test-bot/issues/805
    if ENV["HOMEBREW_GITHUB_ACTIONS"] && !(Formula["ocaml-findlib"].etc/"findlib.conf").exist?
      ENV["OCAMLFIND_CONF"] = Formula["ocaml-findlib"].opt_libexec/"findlib.conf"
    end

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
    # Work around for https://github.com/Homebrew/homebrew-test-bot/issues/805
    if ENV["HOMEBREW_GITHUB_ACTIONS"] && !(Formula["ocaml-findlib"].etc/"findlib.conf").exist?
      ENV["OCAMLFIND_CONF"] = Formula["ocaml-findlib"].opt_libexec/"findlib.conf"
    end

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
