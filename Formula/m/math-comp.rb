class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/refs/tags/mathcomp-1.19.0.tar.gz"
  sha256 "786db902d904347f2108ffceae15ba29037ff8e63a6c58b87928f08671456394"
  license "CECILL-B"
  revision 3
  head "https://github.com/math-comp/math-comp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe578ded99ac581dbb4892205822e06ec3d5d753aa8f8412be06fe0269c06aa5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e02280c42ec43cf8ff9e4c9c9c5db5550dcf37ea3465bc2c79b861da89e832cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e10a7ccd7897d1780906022a26baf7614ec74686be1e765cbdf9ebc511592f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9f5f9efe46c5b0a6ed49997e42dcc34eea97a05e92c67eb54a0cf925199638d"
    sha256 cellar: :any_skip_relocation, ventura:        "129385c0192110aba6dc10f5b0ced11ebe8336c91f7a2b03adcfab1fd9f30724"
    sha256 cellar: :any_skip_relocation, monterey:       "3bf4193ec3a297ce9baef489a69264f82c023fd32fb07298f1adc923151f316c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5357d811a663bf0b5b3de6bc031e1fbc6c0253782f2501f2b65864f81af3f9f"
  end

  depends_on "ocaml" => :build
  depends_on "ocaml-findlib" => :build
  depends_on "coq"

  def install
    # Work around for https://github.com/Homebrew/homebrew-test-bot/issues/805
    if ENV["HOMEBREW_GITHUB_ACTIONS"] && !(Formula["ocaml-findlib"].etc/"findlib.conf").exist?
      ENV["OCAMLFIND_CONF"] = Formula["ocaml-findlib"].opt_libexec/"findlib.conf"
    end

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
    # Work around for https://github.com/Homebrew/homebrew-test-bot/issues/805
    if ENV["HOMEBREW_GITHUB_ACTIONS"] && !(Formula["ocaml-findlib"].etc/"findlib.conf").exist?
      ENV["OCAMLFIND_CONF"] = Formula["ocaml-findlib"].opt_libexec/"findlib.conf"
    end

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
