class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-2.3.0.tar.gz"
  sha256 "19e13c8765007f95b4656d8902bc66e10b072ab94ab51031c5efb860827d05ec"
  license "CECILL-B"
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
  depends_on "coq-hierarchy-builder"
  depends_on "rocq"
  depends_on "rocq-elpi"

  def install
    ENV["OCAMLFIND_CONF"] = Formula["rocq-elpi"].libexec/"lib/findlib.conf"

    args = []
    if build.stable?
      args += %w[-C mathcomp]
      (buildpath/"mathcomp/Makefile.coq.local").write "COQLIB=#{lib}/ocaml/coq\n"
      elisp.install "mathcomp/ssreflect/pg-ssr.el"
    else
      (buildpath/"Makefile.coq.local").append_lines "COQLIB=#{lib}/ocaml/coq\n"
      elisp.install "ssreflect/pg-ssr.el"
    end

    system "make", *args
    system "make", *args, "install"
  end

  test do
    (testpath/"testing.v").write <<~EOS
      From mathcomp Require Import ssreflect seq.

      Parameter T: Type.
      Theorem test (s1 s2: seq T): size (s1 ++ s2) = size s1 + size s2.
      Proof. by elim : s1 =>//= x s1 ->. Qed.

      Check test.
    EOS

    ENV["OCAMLFIND_CONF"] = Formula["rocq-elpi"].libexec/"lib/findlib.conf"
    assert_match(/\Atest\s+: forall/, shell_output("#{Formula["rocq"].bin}/rocq compile testing.v"))
  end
end
