class HierarchyBuilder < Formula
  desc "High level commands to declare a hierarchy based on packed classes"
  homepage "https://github.com/math-comp/hierarchy-builder"
  url "https://github.com/math-comp/hierarchy-builder/releases/download/v1.10.2/hierarchy-builder-1.10.2.tar.gz"
  sha256 "bdd7dccc5248e7500e02fd1745fd17faa41920f43a32ca2de2b2139212ee53b5"
  license "MIT"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3b5f4d1d6606534febc49a70c6ef26b257adae38c2bbf2946f3400f383ee36a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df712866b2cbe4241decc4309c842da8b7b0e878e9845fa61ba5978b7f3d13e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1742cd3a0e219fbfc6bd21822e848e90ba56ccec3a8efd4e5c379524086bedfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "8562c64ebfb06375a32b2d8d1f12e5bd1576ebe7b66fe906c924d450221a7f93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e7aead24d4ff70f0c61a6dd4a4030c563a77dcf367437cb7ae00a11bf020081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2fdd21a3c460b741f966ee40d64756b5084b090cf85453ab7f35899289ddb42"
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
