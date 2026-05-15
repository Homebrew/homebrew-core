class HierarchyBuilder < Formula
  desc "High level commands to declare a hierarchy based on packed classes"
  homepage "https://github.com/math-comp/hierarchy-builder"
  url "https://github.com/math-comp/hierarchy-builder/releases/download/v1.10.2/hierarchy-builder-1.10.2.tar.gz"
  sha256 "bdd7dccc5248e7500e02fd1745fd17faa41920f43a32ca2de2b2139212ee53b5"
  license "MIT"
  revision 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63f91b9b0b9c51d2a3c09f51b90d2050d39e000afc197915f64e7adcec0d36df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c53e865547b235b1c40e219068637d575cf851482e496c655eb179a936bbc02f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55bbe600514b9a25d73c478a71e4859d4075c30cd99ab38b8796453e8cfafb03"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9b283e817570664490222fd61427bdc2a5135ccabf1863aa848f2ee890e0de7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4b7b4222fceff15e9b120e2f003b6b72d1a2eeac2358c02f4ce87f2983d31df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "701e62ae84c7ccfba1c751d3daab8fac91243e84ff064c9541d546225b5fa5b0"
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
