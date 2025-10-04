class HierarchyBuilder < Formula
  desc "High level commands to declare a hierarchy based on packed classes"
  homepage "https://github.com/math-comp/hierarchy-builder"
  url "https://github.com/math-comp/hierarchy-builder/releases/download/v1.10.1/hierarchy-builder-1.10.1.tar.gz"
  sha256 "8fa555024ffee5892b3bf516db2ade1378d9902479fa6109c8f047bf760cdfa4"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35bd362525c05769fcc16683fef86c01e80b63a365930286fdc912896b2f4848"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53b37a7304a07e4ee3ed7cfdfc951e2befd4a19d548fc17c352dc2db0f60c2d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e56941b23009101a257cd9b3f09aad055b9f0d8551ec3f417e33423afb1bc11"
    sha256 cellar: :any_skip_relocation, sonoma:        "b26edb3883602514fcc7d883e143ddad2eb7a8f1ff9796fa9a82907491d3bd46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcf273f10da3a09b950f9ee8642141b62dc0c2e9ff56a474543ba1d41427febb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "162acce4300ab6afc3d72ca5abda155530a9a22bfa09389d8eddf420cddb1408"
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
