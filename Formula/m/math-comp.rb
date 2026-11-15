class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-2.6.0.tar.gz"
  sha256 "b2e8c5c93fdc9bb5ed9b8a06d1c028aa0096a45b1f3ac6c6509d7a6500c72253"
  license "CECILL-B"
  revision 6
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1087eea832702d8615c81bc41ee7961f136791566e662e483657bd63ff12dc46"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cde6f1dbe7eb10969f11a565f04deb3abf3e3835f311c9771703f7ef90bad3db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dc07567cac33180ec2deeed51680b405d5087e834e9d896671540596e2c73b80"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0ba0e3a330c2964a5aa3c3ec98fd88106ad1dd85c4a3fd8f9a81524306958c93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ee400ca04611202b1d6a800605a5b122eac566822093d09a551dc48f3bca1103"
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
