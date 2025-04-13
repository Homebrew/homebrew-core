class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-1.19.0.tar.gz"
  sha256 "786db902d904347f2108ffceae15ba29037ff8e63a6c58b87928f08671456394"
  license "CECILL-B"
  revision 6
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37fb1f8770ce323d60e7849b3309f8accaf18b2983133717d75690791f15fe09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40ed5c77b4b2121aa239a976b013efb9e0e589f0105ad50f44c304cc7388d422"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "315f3de4e2a6edea5d1207fc0220459059fdad6e7c4ce3fd68f84cb023c0c83e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b4c7071557fe00030e6af03c50ef3b2088971c9321a856460f9d3381463cca8"
    sha256 cellar: :any_skip_relocation, ventura:       "95303c41552038239d8a4836bbbf1dd5c2529b4c705eb74f0c636ae225b222f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8efe5c163d39035ce18892f5385020a9ea37d72f99a539fc7374ed8e7eeeedcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9d62a49ccc03fce4f95434502d11351864301b8dfa8a68bedf21d71a2d65fa7"
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
