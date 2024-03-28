class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/releases/download/V8.19.1/coq-8.19.1.tar.gz"
  sha256 "1e535ed924234f18394efce94b12d9247a67e8af29241eb79615804160f21674"
  license "LGPL-2.1-only"
  head "https://github.com/coq/coq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "7f13ef92eeff6e21d81bbed374013088f38246d9450bc8634d2b243736c0146c"
    sha256 arm64_ventura:  "aa0333fdf567061b8e610f4adb7fe7e893e344c4488dc17a86009c7716f7a617"
    sha256 arm64_monterey: "d338d4f1236f9373f1365fc2ce71fe22dcd695e2b4f521d9339e4955ec06906e"
    sha256 sonoma:         "3fe57eb1deebee70fe6d3b5e24a7aacf60d90c7a7941db292e70a1611ce0236e"
    sha256 ventura:        "b62c26db868ad4cc07b48fb8be5b1abc0cf7534e7758cdd9959f5c43c105f343"
    sha256 monterey:       "96ce2e5bde5e1b56f5e90b7a71ed68600d57004baabb8c541a6b2d28756be9a4"
    sha256 x86_64_linux:   "0a3e56daf611ef10e0904a4d3960a2653ebbd1fbef064a3f1514d5efb5f19269"
  end

  depends_on "dune" => :build
  depends_on "gmp"
  depends_on "ocaml"
  depends_on "ocaml-findlib"
  depends_on "ocaml-zarith"

  uses_from_macos "m4" => :build
  uses_from_macos "unzip" => :build

  def install
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
