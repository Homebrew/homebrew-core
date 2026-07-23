class HierarchyBuilder < Formula
  desc "High level commands to declare a hierarchy based on packed classes"
  homepage "https://github.com/math-comp/hierarchy-builder"
  url "https://github.com/math-comp/hierarchy-builder/releases/download/v1.10.3/hierarchy-builder-1.10.3.tar.gz"
  sha256 "577597528f25d217baee91040cc5d7e5f621be7e7a629cccf295e337f73a6d45"
  license "MIT"
  revision 1
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f4a3ed0a9c869830181036a69495e332f04f1ce478d1b7d1f8537ab4b9a4844"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "595a2c28126bafdc724293c83733e6bd2b4a999c69b6333f92df9b40090c48ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65e2a4988d7c0f55b9b24927abe5a19a133323401b3dea9046f271a08c4e5f96"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbf7d20ee3313bb9f669cc5c003d5d08df058143c827c9abc43b4313cc21d786"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0b9e071e53ec9bc3b31e5921780f1e3e40835887e465450a664415b42ec8c93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af76f149491672c1a1961d2112a28bc4212636a4b6649d9a3f62107c6b28c848"
  end

  depends_on "rocq"
  depends_on "rocq-elpi"

  def install
    ENV["OCAMLFIND_CONF"] = Formula["rocq-elpi"].libexec/"lib/findlib.conf"
    system "make", "build"
    system "make", "install", "COQLIB=#{lib}/ocaml/coq"
  end

  test do
    (testpath/"test.v").write <<~ROCQ
      From HB Require Import structures.
      From Stdlib Require Import ssreflect ZArith.

      HB.mixin Record IsAddComoid A := {
        zero : A;
        add : A -> A -> A;
        addrA : forall x y z, add x (add y z) = add (add x y) z;
        addrC : forall x y, add x y = add y x;
        add0r : forall x, add zero x = x;
      }.

      HB.structure Definition AddComoid := { A of IsAddComoid A }.

      Notation "0" := zero.
      Infix "+" := add.

      Check forall (M : AddComoid.type) (x : M), x + x = 0.
    ROCQ

    ENV["OCAMLFIND_CONF"] = Formula["rocq-elpi"].libexec/"lib/findlib.conf"
    assert_equal <<~ROCQ, shell_output("#{Formula["rocq"].bin}/rocq compile test.v")
      forall (M : AddComoid.type) (x : M), x + x = 0
           : Prop
    ROCQ
  end
end
