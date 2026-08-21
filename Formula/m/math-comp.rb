class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-2.6.0.tar.gz"
  sha256 "b2e8c5c93fdc9bb5ed9b8a06d1c028aa0096a45b1f3ac6c6509d7a6500c72253"
  license "CECILL-B"
  revision 1
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21e9e7480afaa9c098932b5794bd3b487a2570cee29cf478b0e5e23105b1ea5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dda55fe838513b5f9b615611b300a461a45eca72f6ff8bf984cf869af6501b95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0de55a7a7a391bcba56a0909794f3e3da851c6b1affb2bbdb5d174e9ad4ebdf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8716d5848e8bc4062523d0b5cde475202c1727b2bc4696abc4a95ac25904400"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c03ecf5729060372140d6af54f22b41f6d3b9d66ddfaa479c660559f8d9711f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ab0a53f30d164f0d3317e39343a9e948fbcdecbcd380eea1e5e96e57c1df394"
  end

  depends_on "ocaml" => :build
  depends_on "ocaml-findlib" => :build
  depends_on "hierarchy-builder"
  depends_on "rocq"
  depends_on "rocq-elpi"
  depends_on "rocq-micromega-plugin"

  def install
    ENV["OCAMLFIND_CONF"] = Formula["rocq-elpi"].libexec/"lib/findlib.conf"
    ENV.prepend_path "OCAMLPATH", formula_opt_lib("rocq-micromega-plugin")/"ocaml"

    system "make"
    system "make", "install", "COQLIBINSTALL=#{lib}/ocaml/coq/user-contrib"
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
    ENV.prepend_path "OCAMLPATH", formula_opt_lib("rocq-micromega-plugin")/"ocaml"
    assert_match(/\Atest\s+: forall/, shell_output("#{Formula["rocq"].bin}/rocq compile testing.v"))
  end
end
