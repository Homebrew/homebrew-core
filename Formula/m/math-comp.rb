class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-2.5.0.tar.gz"
  sha256 "3db2f4b1b7f9f5a12d3d0c4ba4e325a26a77712074200319660c0e67e25679f1"
  license "CECILL-B"
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6ebdb3f0c5511e6e660fc529beafc659f4a178dfbe09daafa9a659ce9aaa2e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f13c9a57821e1e7a78ff873c1591590bdc09e42f70507e54752c510c13896c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7d28a5e6399ea7380f2ba29d4bd476c1d1883e3e8ee84c3d5e5e9b34a603df1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d41cc37c0ff9e7cc72c1dde6a453d0797fee10e14ad10a6e5efb40794c71b96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "222e8ece658e5273ced1047748b2c0c8942d45c70fdc40c1343fda9dc2728ea3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31ebbf2e8853abc7215f2535a0a7dff34246b2cb44d59488a47fdb07e02e9383"
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
