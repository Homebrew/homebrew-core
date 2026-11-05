class HierarchyBuilder < Formula
  desc "High level commands to declare a hierarchy based on packed classes"
  homepage "https://github.com/math-comp/hierarchy-builder"
  url "https://github.com/math-comp/hierarchy-builder/releases/download/v1.10.3/hierarchy-builder-1.10.3.tar.gz"
  sha256 "577597528f25d217baee91040cc5d7e5f621be7e7a629cccf295e337f73a6d45"
  license "MIT"
  revision 7
  compatibility_version 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9e7dec7c7fe8aee017610f3d7b0f1b0450b57b8fa1324212f7d88d4f8cb58fe6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fa07ca332fff4891992c040a962dc1c7b04718fe50bca0b041800b9a2b6bd589"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a7b36f01e936928add68b8c217ca2680883827fd6f8b275aec6990730aae04fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "244f078de9f5566fb1097f195cc71e3fbe63a9bb2f8f55dc669da982798dd6c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "088c56937f67fed88ad2fe71a986c637c43d0fffac6151252ebaacafd145a607"
  end

  depends_on "rocq"
  depends_on "rocq-elpi"

  def install
    ENV["OCAMLFIND_CONF"] = formula_opt_libexec("rocq-elpi")/"lib/findlib.conf"
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

    ENV["OCAMLFIND_CONF"] = formula_opt_libexec("rocq-elpi")/"lib/findlib.conf"
    assert_equal <<~ROCQ, shell_output("#{formula_opt_bin("rocq")}/rocq compile test.v")
      forall (M : AddComoid.type) (x : M), x + x = 0
           : Prop
    ROCQ
  end
end
