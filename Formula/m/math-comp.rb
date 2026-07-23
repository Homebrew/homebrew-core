class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-2.6.0.tar.gz"
  sha256 "b2e8c5c93fdc9bb5ed9b8a06d1c028aa0096a45b1f3ac6c6509d7a6500c72253"
  license "CECILL-B"
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfbbf02ce794bd69d3d4fd0c072f5da7ff758cd602bb6cf0558612e9a9289a3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b949d3bf9c6c9bb8ba38281f4ee245ad240a07c3863be3bc35b0e177ff8bbec7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b74c2cc4f30af180db25420ba6302e01d9e3c92a0e086626472aafe01c484c6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e81ca3f738399430d75bc79fbf4c6972cdcb14cb1f781d97153f0927b882986"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c544ebc1dffd7370433f4a3ade49657f3b22c4a1308800115b3b8b831b837fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb79765127d6e0f67224aa34a7603c10f2116f52623154eaa69174f75a1c7335"
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
