class HierarchyBuilder < Formula
  desc "High level commands to declare a hierarchy based on packed classes"
  homepage "https://github.com/math-comp/hierarchy-builder"
  url "https://github.com/math-comp/hierarchy-builder/releases/download/v1.10.1/hierarchy-builder-1.10.1.tar.gz"
  sha256 "8fa555024ffee5892b3bf516db2ade1378d9902479fa6109c8f047bf760cdfa4"
  license "MIT"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d396e1b62e010d59daecdd46a8b5347734bccc232c41989055d98be3b06d4220"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d31310a9313e67b0310353ae5d0ac4230530b2f041bcafa2c7f0194fce7896e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d42825bd39b10f11c6763086c5c0181f6be27b717ca655a80a59c22123808d2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "12790cc24bb58c87b1725335bba4b2fa9fee9aa2c5ce6b3a59317571ca44e446"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "339377ffeaa02842ffd1da1262034745248ad140e5dfdb9e0484ecab4eac52ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8aabf5bcc9d30ba08a64e54e2b8f41acd9c5c670eaa4607464cc72ba0132c2eb"
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
    assert_equal <<~EOS, shell_output("#{Formula["rocq"].bin}/rocq compile test.v")
      forall (M : AddComoid.type) (x : M), x + x = 0
           : Prop
    EOS
  end
end
