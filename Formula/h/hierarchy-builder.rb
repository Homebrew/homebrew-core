class HierarchyBuilder < Formula
  desc "High level commands to declare a hierarchy based on packed classes"
  homepage "https://github.com/math-comp/hierarchy-builder"
  url "https://github.com/math-comp/hierarchy-builder/releases/download/v1.10.1/hierarchy-builder-1.10.1.tar.gz"
  sha256 "8fa555024ffee5892b3bf516db2ade1378d9902479fa6109c8f047bf760cdfa4"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b596ee3cfb1c054d136163cc636869e11c343fbd10778750cae303d6123edb71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1cb39a2337b16388228d5efbc29eb0b358c6efd47b843246ae82d9398ca5800"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10429ee84f930e6ce3111647820c2f8c941a4bc0fe3784cbe7bc0fd2b2c9b572"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "289d661ef28a03a4d0fa042a61a523f5f3c6bfe33032ceab6f427db93f2d0327"
    sha256 cellar: :any_skip_relocation, sonoma:        "43688cdf9f6b15306d69aa02becfea9bea883a9e0c0d8936d5b7fe051b537811"
    sha256 cellar: :any_skip_relocation, ventura:       "28f73a673c7ab41b112cb84e65871bb44871c5b066064ed9feb9ce4f9d1422a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10420e9b3f416c64b133a4ab7e445524869a77b721d478be8301b6b5343cd4f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65473696ae3f70c57055500d9ff29a60c40ca126b760a520a7927526ad3095dd"
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
