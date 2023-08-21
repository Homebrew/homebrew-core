class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/mathcomp-1.17.0.tar.gz"
  sha256 "1779bcdac5d23d90997627364a5943ef4883c6eb54d67ddbb1dfbe6b7795a188"
  license "CECILL-B"
  revision 1
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3186adb11d4514d8c6d12dbf04260dc806aea29bc16b3cbd9dccfdb52d6f7059"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94f8954a1405cad8a329d1503114d4852e921c7afc66d94aa225651dbd53d743"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d514083ddf8572e14a423d560c7519fe13e7b5d0e581e9ee1db26b3efe272e5"
    sha256 cellar: :any_skip_relocation, ventura:        "e09517b8d92ebcbb3285d2320079c9df50277f1c3254d98f1a3ffd0bdc70a4d7"
    sha256 cellar: :any_skip_relocation, monterey:       "68e9fffd287137266c5378b64fa2c98d0f3b115368593277d216b72af4840c2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "91840883012bcc64b6bf43ea554c2568ac5a91de2cf616a0199a0918afb6b73d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5570b0f3dc1020a8229573f89d38cb3e2064539ef061b8cec693c632d3ac699e"
  end

  depends_on "ocaml" => :build
  depends_on "ocaml-findlib" => :build
  depends_on "coq"

  def install
    coqlib = "#{lib}/coq/"

    (buildpath/"mathcomp/Makefile.coq.local").write <<~EOS
      COQLIB=#{coqlib}
    EOS

    cd "mathcomp" do
      system "make", "Makefile.coq"
      system "make", "-f", "Makefile.coq", "MAKEFLAGS=#{ENV["MAKEFLAGS"]}"
      system "make", "install", "MAKEFLAGS=#{ENV["MAKEFLAGS"]}"

      elisp.install "ssreflect/pg-ssr.el"
    end

    doc.install Dir["docs/*"]
  end

  test do
    (testpath/"testing.v").write <<~EOS
      From mathcomp Require Import ssreflect seq.

      Parameter T: Type.
      Theorem test (s1 s2: seq T): size (s1 ++ s2) = size s1 + size s2.
      Proof. by elim : s1 =>//= x s1 ->. Qed.

      Check test.
    EOS

    coqc = Formula["coq"].opt_bin/"coqc"
    cmd = "#{coqc} -R #{lib}/coq/user-contrib/mathcomp mathcomp testing.v"
    assert_match(/\Atest\s+: forall/, shell_output(cmd))
  end
end
