class HierarchyBuilder < Formula
  desc "High level commands to declare a hierarchy based on packed classes"
  homepage "https://github.com/math-comp/hierarchy-builder"
  url "https://github.com/math-comp/hierarchy-builder/releases/download/v1.10.2/hierarchy-builder-1.10.2.tar.gz"
  sha256 "bdd7dccc5248e7500e02fd1745fd17faa41920f43a32ca2de2b2139212ee53b5"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee80299b86d2ec8a96288ce4d1e3e6ca53d881afa9b98c5911cb729abcac86de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22fa7893e6c2a67626c46af2c6cfc4b4f6928c2cf29fe0fe64ebbbebb878edcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c689944d54d85b1acd7f0fe8329e9806d352b47945cedbc1540ab9b14f3c7001"
    sha256 cellar: :any_skip_relocation, sonoma:        "5245c8e980347a1ca6f9a83a30a79ada642ec3ed9a3a379d47fa1cdb825eef5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d6f66d5cfb09ce2c2431f62fd38adcd79e5f32ce8699aeab17fbac5b494b1a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "825c3375a620062156df0b02bd08047e4dc14b03b58c63941811f02ae5e7edc9"
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
