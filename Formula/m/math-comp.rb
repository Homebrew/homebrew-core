class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-2.4.0.tar.gz"
  sha256 "6307218d7e434fb6ffc81b9275c673d3f7f1f4884ad59b904abd205c437021a0"
  license "CECILL-B"
  revision 3
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "908f5d0bd5477080b0a551d795fc8dd4f6fb98e4c874948d73e2c90f8698530c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eac87e535ea5186041ea4cfd99727383a650db2123f5c5cecc289a89ffe08c95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c107c4e8a28915845a0325784f02dd8204a794a88e0800ecf351f48b7391e503"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c3fae8f2f9b3c9c634748de8bdfb6929627325630136cbce33edd8cb48fefd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8da333575574023deb548d3c5875e50415f09c73320deb19059a89ba07e2b39c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9594a634d64b7eb0059b38bb23ce7a200d6ca2b1316f5283046d1e495320b3a3"
  end

  depends_on "ocaml" => :build
  depends_on "ocaml-findlib" => :build
  depends_on "hierarchy-builder"
  depends_on "rocq"
  depends_on "rocq-elpi"

  def install
    ENV["OCAMLFIND_CONF"] = Formula["rocq-elpi"].libexec/"lib/findlib.conf"
    (buildpath/"Makefile.coq.local").append_lines "COQLIB=#{lib}/ocaml/coq\n"

    system "make"
    system "make", "install"
    elisp.install "ssreflect/pg-ssr.el"
  end

  test do
    (testpath/"testing.v").write <<~ROCQ
      From mathcomp Require Import ssreflect seq.

      Parameter T: Type.
      Theorem test (s1 s2: seq T): size (s1 ++ s2) = size s1 + size s2.
      Proof. by elim : s1 =>//= x s1 ->. Qed.

      Check test.
    ROCQ

    ENV["OCAMLFIND_CONF"] = Formula["rocq-elpi"].libexec/"lib/findlib.conf"
    assert_match(/\Atest\s+: forall/, shell_output("#{Formula["rocq"].bin}/rocq compile testing.v"))
  end
end
