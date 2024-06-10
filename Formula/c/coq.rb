class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/releases/download/V8.19.1/coq-8.19.1.tar.gz"
  sha256 "1e535ed924234f18394efce94b12d9247a67e8af29241eb79615804160f21674"
  license "LGPL-2.1-only"
  revision 1
  head "https://github.com/coq/coq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "d3a5f3a7f582755ac089a9a03ee34f4d4d245e1a07f39cfe03b4498eee1cd3b8"
    sha256 arm64_ventura:  "6a9553764a0a0a8e9a8100100e71e02954a8b7fe05b80a3e8dfc56fc93f7e799"
    sha256 arm64_monterey: "7cbc3d9565fb6d760e6cf9d525f7fda67fa8048f10af1c2567f73f914a70bfad"
    sha256 sonoma:         "9307527ca25209485d35abef99bf2569f9868ac1ddab9e481b94bc24a029ad72"
    sha256 ventura:        "27fe173b76690d141e73d688e960b7375aeb40ecbe457577bf1d172947e4f9c2"
    sha256 monterey:       "900c3bf8a15780c078658d15195b4193bffe0231c25494fa36fb7cbb0f576d68"
    sha256 x86_64_linux:   "aed6466a06ef1fb083aa6c74e35a7ef0114d991448b72331c3830168402feebc"
  end

  depends_on "dune" => :build
  depends_on "gmp"
  depends_on "ocaml"
  depends_on "ocaml-findlib"
  depends_on "ocaml-zarith"

  uses_from_macos "m4" => :build
  uses_from_macos "unzip" => :build

  def install
    # Work around for https://github.com/Homebrew/homebrew-test-bot/issues/805
    if ENV["HOMEBREW_GITHUB_ACTIONS"] && !(Formula["ocaml-findlib"].etc/"findlib.conf").exist?
      ENV["OCAMLFIND_CONF"] = Formula["ocaml-findlib"].opt_libexec/"findlib.conf"
    end
    ENV.prepend_path "OCAMLPATH", Formula["ocaml-zarith"].opt_lib/"ocaml"
    ENV.prepend_path "OCAMLPATH", Formula["ocaml-findlib"].opt_lib/"ocaml"
    system "./configure", "-prefix", prefix,
                          "-mandir", man,
                          "-libdir", HOMEBREW_PREFIX/"lib/ocaml/coq",
                          "-docdir", pkgshare/"latex"
    system "make", "dunestrap"
    system "dune", "build", "-p", "coq-core,coq-stdlib,coqide-server,coq"
    system "dune", "install", "--prefix=#{prefix}",
                              "--mandir=#{man}",
                              "--libdir=#{lib}/ocaml",
                              "coq-core",
                              "coq-stdlib",
                              "coqide-server",
                              "coq"
  end

  test do
    # Work around for https://github.com/Homebrew/homebrew-test-bot/issues/805
    if ENV["HOMEBREW_GITHUB_ACTIONS"] && !(Formula["ocaml-findlib"].etc/"findlib.conf").exist?
      ENV["OCAMLFIND_CONF"] = Formula["ocaml-findlib"].opt_libexec/"findlib.conf"
    end
    (testpath/"testing.v").write <<~EOS
      Require Coq.micromega.Lia.
      Require Coq.ZArith.ZArith.

      Inductive nat : Set :=
      | O : nat
      | S : nat -> nat.
      Fixpoint add (n m: nat) : nat :=
        match n with
        | O => m
        | S n' => S (add n' m)
        end.
      Lemma add_O_r : forall (n: nat), add n O = n.
      Proof.
      intros n; induction n; simpl; auto; rewrite IHn; auto.
      Qed.

      Import Coq.micromega.Lia.
      Import Coq.ZArith.ZArith.
      Open Scope Z.
      Lemma add_O_r_Z : forall (n: Z), n + 0 = n.
      Proof.
      intros; lia.
      Qed.
    EOS
    system bin/"coqc", testpath/"testing.v"
    # test ability to find plugin files
    output = shell_output("#{Formula["ocaml-findlib"].bin}/ocamlfind query coq-core.plugins.ltac")
    assert_equal "#{HOMEBREW_PREFIX}/lib/ocaml/coq-core/plugins/ltac", output.chomp
  end
end
