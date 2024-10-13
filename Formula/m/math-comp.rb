class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-1.19.0.tar.gz"
  sha256 "786db902d904347f2108ffceae15ba29037ff8e63a6c58b87928f08671456394"
  license "CECILL-B"
  revision 5
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "56be5fa32ef4fb012b8fed9a47c9c7ae4630013eb31ac350a3cee7f4e152e2f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c65e53df5bd92f7d2b2faa904b51f8aed7b9b7afa0154696787e78c95094ba58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d264a1afa803c6e911fb71cbe8c2105bd966db11fc744a41ce749b4409022de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82d8033f4b2d53e096d78553ca15ce4c1b70da10062d9b15d015d6e4b2d90e81"
    sha256 cellar: :any_skip_relocation, sonoma:         "dbd53984d02d5022a36deca05b2ff0603a18af8bede8433538b6488de162a192"
    sha256 cellar: :any_skip_relocation, ventura:        "18a7485c231fa966e42e1f92efa65d9d4a90f0638d11115669f8fe1abbd0768c"
    sha256 cellar: :any_skip_relocation, monterey:       "9a73af8a9943e94f1d6b66bf00062268d490d343d3992ad734553d45f55b4b50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b26a7b1d822620b5573ee79a908440d66e06eadfede3e0977ac1a60cc57eb85b"
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
