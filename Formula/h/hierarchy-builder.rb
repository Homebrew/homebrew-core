class HierarchyBuilder < Formula
  desc "High level commands to declare a hierarchy based on packed classes"
  homepage "https://github.com/math-comp/hierarchy-builder"
  url "https://github.com/math-comp/hierarchy-builder/releases/download/v1.10.3/hierarchy-builder-1.10.3.tar.gz"
  sha256 "577597528f25d217baee91040cc5d7e5f621be7e7a629cccf295e337f73a6d45"
  license "MIT"
  revision 5
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "58c173707e6b1bbfa2aaa6c108c2af1283dd80a449e223fe678d56c2ef881461"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "632e9a56b6bf5c7dcdc6c09a07ed34c6d7e893e14bfcd4070d1867341541fad8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cd71aaac4d4ee8af41b6fe1f9c00430115b85dd8ccc192fc7cbf3f8bcbf81421"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a66de4596367767841714bf9016ed2457c924e6da36d956826760537dc69c5f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4e97eecf404a301c89a35d662c6f4825129e1eb9394b58533aa0a5d38d68fddf"
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
