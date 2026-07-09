class HierarchyBuilder < Formula
  desc "High level commands to declare a hierarchy based on packed classes"
  homepage "https://github.com/math-comp/hierarchy-builder"
  url "https://github.com/math-comp/hierarchy-builder/releases/download/v1.10.3/hierarchy-builder-1.10.3.tar.gz"
  sha256 "577597528f25d217baee91040cc5d7e5f621be7e7a629cccf295e337f73a6d45"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38bd66a08ef1c8136bc3ae14e606df46e988037b9c695124b0b9b30836118841"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e43b4425f925819d4129a020c45482a3ccaeaa9c75482ece3476b814aa22112"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "546305ea3f772aeafc60c2dfce0e4c02e6ce377c6da75b54c4f8bfe1910abd79"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ff6712b32eff9d8ccfec486208e625f0b1012b71690955adc448ca47e9fd2c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da3f37190ab26febc638c58d6754ae58f01d7492baf0a66dbb15f4af1f2d6e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cbbf42a8970c735ca365371bb290d7660961de7649b8565587c05b6622874cf"
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
