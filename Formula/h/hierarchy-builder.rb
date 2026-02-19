class HierarchyBuilder < Formula
  desc "High level commands to declare a hierarchy based on packed classes"
  homepage "https://github.com/math-comp/hierarchy-builder"
  url "https://github.com/math-comp/hierarchy-builder/releases/download/v1.10.2/hierarchy-builder-1.10.2.tar.gz"
  sha256 "bdd7dccc5248e7500e02fd1745fd17faa41920f43a32ca2de2b2139212ee53b5"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8435ecf6b9adc5053223492cc87c851436c18dab2a1b3ae657d39e50b479dadd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "110d9d286ee59cb5299a185d3c9f15f60ca419e8a10674b28ecba8ee5dee1f99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ad6518115658f4143bc2aeaa4fb332113dd85766e6c28aedfeed6cbb54da7e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "55d0e68f65c555c9a851d8b13c98df625caac4af50a6dc91223516c86a3ce7b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f475589256ca06143b501f1b4ae73f5cb422243cf69bf9509d4384dd5b2c6d75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbe18a947168ead238ceb27cd872927b084fa445f6035abbb361e4ec37df90f4"
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
