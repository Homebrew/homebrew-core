class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-2.6.0.tar.gz"
  sha256 "b2e8c5c93fdc9bb5ed9b8a06d1c028aa0096a45b1f3ac6c6509d7a6500c72253"
  license "CECILL-B"
  revision 6
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7d3144438d31c6be437e7c32ef2ea3106adb4d4adf34cc6fd5974a4ffa43a2c7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "273e510695540191133aa6e07ba33526dff91161acf1ba0439f789d9c7914977"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6d1f87332891e7942bc92301f48ac7906771f23554106c3fbbe8b162c8643b16"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "03b93870692eddc46c61bf0eae94046b2161c1b0f86b84262050558eacbd8a4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bc856370b46bedef0f1e168c771f9a0a4c5e9cc77bc6ed737b6a77a99ffc7843"
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
