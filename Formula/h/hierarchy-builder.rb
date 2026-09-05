class HierarchyBuilder < Formula
  desc "High level commands to declare a hierarchy based on packed classes"
  homepage "https://github.com/math-comp/hierarchy-builder"
  url "https://github.com/math-comp/hierarchy-builder/releases/download/v1.10.3/hierarchy-builder-1.10.3.tar.gz"
  sha256 "577597528f25d217baee91040cc5d7e5f621be7e7a629cccf295e337f73a6d45"
  license "MIT"
  revision 3
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a98c84826e077c75a13c907d9111f6a7174ef97509741aae4c05c41c067d14b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "772ba09e4a4c8adcda7ac47aa49738a6be58bf3bcb5e6bdd68b9cd5fa249b3e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a8cb2cc028ccc10421b0f08a1e7f7356681a8600de139e45659cb82b73221df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a74387bbb64cb6cc57c4ea99e961479439d9218ca0298928aee01ab2f2e15eac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "385456012114ce828db0c01d46cb0cefb3c85ec700ed69338c553e76ded8bfb2"
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
