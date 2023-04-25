class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/mathcomp-1.16.0.tar.gz"
  sha256 "36fe4f5487f4685db9c6e6affa92abb47248440e6d4dfaaa01ab31df5fd4b513"
  license "CECILL-B"
  revision 3
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ace12cde40f2db32630a1ff753610edc8bcb342d26a9d10950b5fd6f98f2c25a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db32dee17e571106f2ec790dda283c73fc35125584f79cd48b4c385673dc972d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c8df168f2dd02eebf73a5c0b9e07c05a7e6ddf2920cac2972b6dc161607483a"
    sha256 cellar: :any_skip_relocation, ventura:        "008e294ef785cd25162d2b8330995ff3efdc7a550f290649c847b215b785467a"
    sha256 cellar: :any_skip_relocation, monterey:       "4be2eef559fb8201c7e9aae3583332b1e964d876a75ee55b809e1bdc34d35214"
    sha256 cellar: :any_skip_relocation, big_sur:        "d09925860278d2ffb8e5df2463757b6b2f3e9809a3eb2b4385ee620bb67dec0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cd07c39a4bd148ad1f8644088869a67291af294e58553c58a1367dfeaa70261"
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
