class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/releases/download/V8.20.1/coq-8.20.1.tar.gz"
  sha256 "09ad238cc7930d59564b032be2a8a1fd10d6ef845364d739072d04090a6d3cc2"
  license "LGPL-2.1-only"
  head "https://github.com/coq/coq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "65a6d3984df7191476d584bf10ad5a20f7f5b79985f3b2550ede68ee9c84204c"
    sha256 arm64_sonoma:  "f0fbf43c5369353ec0b2ca64b5132bb81b34c1ed2e3dc3e51aefb35232807873"
    sha256 arm64_ventura: "6a647ecd4b7562cac8cf430dc897db55cad68aa2f41f727491c9d25a9528f1da"
    sha256 sonoma:        "37910c96de115af903170ebc56447092de187c4e1eda11c44be0fdc77bf0881e"
    sha256 ventura:       "3d1168df2643f5ab98fd7a721ca12bd3dff10f447918d6f3962d1867abfdc1ff"
    sha256 arm64_linux:   "1d2e24d6e8d829cf454df015d3b03a86e0779639825b5cfe60800bcc03fe6d3f"
    sha256 x86_64_linux:  "df412ed51c3f13261aa40bd9cccf2544ffcc6993ede2371f334e63d0ad8ff473"
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
