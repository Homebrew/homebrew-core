require "language/haskell"

class Cedille < Formula
  include Language::Haskell::Cabal

  desc "Language based on the Calculus of Dependent Lambda Eliminations"
  homepage "https://cedille.github.io/"
  revision 2

  stable do
    url "https://github.com/cedille/cedille/archive/v1.1.2.tar.gz"
    sha256 "cf6578256105c7042b99a70a897c1ed60f856b28628b79205eb95730863b71cb"

    resource "ial" do
      url "https://github.com/cedille/ial/archive/v1.5.0.tar.gz"
      sha256 "f003a785aba6743f4d76dcaafe3bc08bf879b2e1a7a198a4f192ced12b558f46"
    end
  end

  bottle do
    sha256 "af1b087e82b262424780239acd95518da9619ff369ed516a5960ddb2a0aca521" => :catalina
    sha256 "4725ad14b9f90f69c5a311f858e759eeb640182cfb3181e8f8e8dcdb2d6245a4" => :mojave
    sha256 "b86f90724908cc565b544980180ec294417f3d2e0b70fd9301fecd17697b1504" => :high_sierra
  end

  head do
    url "https://github.com/cedille/cedille.git"

    resource "ial" do
      url "https://github.com/cedille/ial.git"
    end
  end

  depends_on "agda" => :build
  depends_on "cabal-install" => :build
  depends_on "ghc@8.8"

  # needed to build with agda 2.6.1
  # taken from https://github.com/cedille/cedille/pull/144/files
  # but added at the bottom to apply cleanly on v1.1.2
  # remove once this is merged into cedille, AND formula updated to
  # a release that contains it
  patch :DATA

  def install
    resource("ial").stage buildpath/"ial"

    cabal_sandbox do
      # build tools
      cabal_install_tools "alex", "happy", "cpphs"

      # build dependencies
      cabal_install "ieee754"

      # use the sandbox when building with Agda
      ENV["GHC_PACKAGE_PATH"] = "#{buildpath/Dir[".cabal-sandbox/*packages.conf.d/"].first}:"

      # build
      system "make", "core/cedille-core", "cedille-mac"
    end

    # binaries and elisp
    bin.install "core/cedille-core"
    bin.install "cedille-mac" => "cedille"
    elisp.install "cedille-mode.el", "cedille-mode", "se-mode"

    # standard libraries
    (lib/"cedille").install "lib", "new-lib"

    # documentation
    doc.install Dir["docs/html/*"]
    (doc/"semantics").install "docs/semantics/paper.pdf"
    info.install "docs/info/cedille-info-main.info"
  end

  test do
    coretest = testpath/"core-test.ced"
    coretest.write <<~EOS
      module core-test.

      id = Λ X: ★. λ x: X. x.

      cNat : ★ = ∀ X: ★. Π _: X. Π _: Π _: X. X. X.
      czero = Λ X: ★. λ x: X. λ f: Π _: X. X. x.
      csucc = λ n: cNat. Λ X: ★. λ x: X. λ f: Π _: X. X. f (n ·X x f).

      iNat : Π n: cNat. ★
        = λ n: cNat. ∀ P: Π _: cNat. ★.
          Π _: P czero. Π _: ∀ n: cNat. Π p: P n. P (csucc n). P n.
      izero
        = Λ P: Π _: cNat. ★.
          λ base: P czero. λ step: ∀ n: cNat. Π p: P n. P (csucc n). base.
      isucc
        = Λ n: cNat. λ i: iNat n. Λ P: Π _: cNat. ★.
          λ base: P czero. λ step: ∀ n: cNat. Π p: P n. P (csucc n).
            step -n (i ·P base step).

      Nat : ★ = ι x: cNat. iNat x.
      zero = [ czero, izero @ x. iNat x ].
      succ = λ n: Nat. [ csucc n.1, isucc -n.1 n.2 @x. iNat x ].
    EOS

    cedilletest = testpath/"cedille-test.ced"
    cedilletest.write <<~EOS
      module cedille-test.

      id : ∀ X: ★. X ➔ X = Λ X. λ x. x.

      cNat : ★ = ∀ X: ★. X ➔ (X ➔ X) ➔ X.
      czero : cNat = Λ X. λ x. λ f. x.
      csucc : cNat ➔ cNat = λ n. Λ X. λ x. λ f. f (n x f).

      iNat : cNat ➔ ★
        = λ n: cNat. ∀ P: cNat ➔ ★.
          P czero ➔ (∀ n: cNat. P n ➔ P (csucc n)) ➔ P n.
      izero : iNat czero = Λ P. λ base. λ step. base.
      isucc : ∀ n: cNat. iNat n ➔ iNat (csucc n)
        = Λ n. λ i. Λ P. λ base. λ step. step -n (i base step).

      Nat : ★ = ι n: cNat. iNat n.
      zero : Nat = [ czero, izero ].
      succ : Nat ➔ Nat = λ n. [ csucc n.1, isucc -n.1 n.2 ].
    EOS

    # test cedille-core
    system bin/"cedille-core", coretest

    # test cedille
    system bin/"cedille", cedilletest
  end
end
__END__
diff --git a/src/to-string.agda b/src/to-string.agda
index 2505942..051a2da 100644
--- a/src/to-string.agda
+++ b/src/to-string.agda
@@ -100,9 +100,9 @@ no-parens {TK} _ _ _ = tt
 no-parens {QUALIF} _ _ _ = tt
 no-parens {ARG} _ _ _ = tt
 
-pattern ced-ops-drop-spine = cedille-options.options.mk-options _ _ _ _ ff _ _ _ ff _
-pattern ced-ops-conv-arr = cedille-options.options.mk-options _ _ _ _ _ _ _ _ ff _
-pattern ced-ops-conv-abs = cedille-options.options.mk-options _ _ _ _ _ _ _ _ tt _
+pattern ced-ops-drop-spine = cedille-options.mk-options _ _ _ _ ff _ _ _ ff _
+pattern ced-ops-conv-arr = cedille-options.mk-options _ _ _ _ _ _ _ _ ff _
+pattern ced-ops-conv-abs = cedille-options.mk-options _ _ _ _ _ _ _ _ tt _
 
 drop-spine : cedille-options.options → {ed : exprd} → ctxt → ⟦ ed ⟧ → ⟦ ed ⟧
 drop-spine ops @ ced-ops-drop-spine = h
