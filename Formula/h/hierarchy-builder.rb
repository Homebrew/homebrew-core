class HierarchyBuilder < Formula
  desc "High level commands to declare a hierarchy based on packed classes"
  homepage "https://github.com/math-comp/hierarchy-builder"
  url "https://github.com/math-comp/hierarchy-builder/releases/download/v1.10.2/hierarchy-builder-1.10.2.tar.gz"
  sha256 "bdd7dccc5248e7500e02fd1745fd17faa41920f43a32ca2de2b2139212ee53b5"
  license "MIT"
  revision 4

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edc11fa3e8253c2058fd25f195f89b3fd5056838dec7342975d16903a2757cd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df34f47ebb916cddc88a4cd7474c155df6004dca53ef7f0f59b16f0cf6251171"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e1ed20ca222c990fec8c74f1658f39132cb3f8bc43fead4868a733e698eb122"
    sha256 cellar: :any_skip_relocation, sonoma:        "b21d207ae42cbb5466eec8e31c0a2b1a6eaaf3e921735b75197f7d549641d753"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ebb13c22ff6a196c9cccd8134bce760662e1b024c09da3402a862faa556b39f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca8f1dae64c88a25d2df84e25549980dd3bde8aa8fa3546ee957e82520f373e3"
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
