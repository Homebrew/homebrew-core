class HierarchyBuilder < Formula
  desc "High level commands to declare a hierarchy based on packed classes"
  homepage "https://github.com/math-comp/hierarchy-builder"
  url "https://github.com/math-comp/hierarchy-builder/releases/download/v1.10.3/hierarchy-builder-1.10.3.tar.gz"
  sha256 "577597528f25d217baee91040cc5d7e5f621be7e7a629cccf295e337f73a6d45"
  license "MIT"
  revision 2
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddd2653b1324e02bf8dd2d665246ecc53f001014a7d8bffc0b35a7d5d012a5a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3038eb854c816d0b2df588906dcf50e328bd1b3f62aae712ab83cd88b3fc8c7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e62a73df983012b340fe04f70a35293118dfa3ce251cde3bad18e1889cc2a7b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "46f091e93937d22569139e6c8ca74980d2e7a4e07b69b8539d224bf03dfbba43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92af623a99114f5f6c86e94a1d32d10d8a049cd4b5f88b49b7b90588d5c84438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3b32a23860bed3f4875e9b8d0542a9e9ed22fb796f8679224959a86b05112fa"
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
