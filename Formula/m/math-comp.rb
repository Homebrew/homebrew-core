class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-2.6.0.tar.gz"
  sha256 "b2e8c5c93fdc9bb5ed9b8a06d1c028aa0096a45b1f3ac6c6509d7a6500c72253"
  license "CECILL-B"
  revision 2
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e0005fddb1553f1b986c4ae8b89e6fe6c738ee66bd1f2e0d09c607244c871fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "392202fc132426734ac0a4d31d2d00a3324fc711949900a64b86bc754544a064"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "797751273b81b85417a36c0ab04a6b7261c11412abc84d5554e52f980674575b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aecfb2d882f7969c7207d7962f007e143cf7f70eb0f566bffa821489e5e1ad32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16d314feafa7deab253b8b5fe96dda04186ce9c4dff8d7091a019b0f9d02587a"
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
