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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ae9094b790e79578e966186e84c3799239423360538079a6bde813a7c441c0f6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f94cc1021fe78cd8d91509175a283a574049d4e057560c039bad460e5aae353b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "56bbcace1cfb8681b70e04c702587f8c4f3a2b9ce03a278fc2a90d67a9541758"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d1466e4f24deed804fcb7fc8309d50d9874b3dc4ee3ed646ca86b568ac020633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "eda7dfaa1c63b911da7e6a2ff811ad4cc6813bcfa11056dff237f1161ec94f59"
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
