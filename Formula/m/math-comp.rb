class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-2.6.0.tar.gz"
  sha256 "b2e8c5c93fdc9bb5ed9b8a06d1c028aa0096a45b1f3ac6c6509d7a6500c72253"
  license "CECILL-B"
  revision 4
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "503de4ee024d97a491445d8342e72833f97d00f5c0f2468a024dfd4fc5fba259"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "26f8cd0e402f78528b55a57e2a8b6614e6285fafebb6088ef5e354f0799482c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f6d0bcf192c5b19c42e475bd27421a2447efdfea4821a568d970378e5d14a64b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "158de638d733148861f3d3b97f373fedee7b71eb6f8fc8db1a5f212aad576221"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ed398244a1bfcb8087fd44e5e66a87377384a2e4f687c118a1898e685ebb6880"
  end

  depends_on "ocaml" => :build
  depends_on "ocaml-findlib" => :build
  depends_on "hierarchy-builder"
  depends_on "rocq"
  depends_on "rocq-elpi"
  depends_on "rocq-micromega-plugin"

  def install
    ENV["OCAMLFIND_CONF"] = formula_opt_libexec("rocq-elpi")/"lib/findlib.conf"
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

    ENV["OCAMLFIND_CONF"] = formula_opt_libexec("rocq-elpi")/"lib/findlib.conf"
    ENV.prepend_path "OCAMLPATH", formula_opt_lib("rocq-micromega-plugin")/"ocaml"
    assert_match(/\Atest\s+: forall/, shell_output("#{formula_opt_bin("rocq")}/rocq compile testing.v"))
  end
end
