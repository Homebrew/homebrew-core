class Agda < Formula
  desc "Dependently typed functional programming language"
  homepage "https://wiki.portal.chalmers.se/agda/"
  license "BSD-3-Clause"
  revision 2

  stable do
    url "https://hackage.haskell.org/package/Agda-2.6.4.1/Agda-2.6.4.1.tar.gz"
    sha256 "23248a9b3c50c81ea4751518a66f2a6144617b6a5a9202686b54e33bc9cbd080"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib/archive/refs/tags/v2.0.tar.gz"
      sha256 "14eecb83d62495f701e1eb03ffba59a2f767491f728a8ab8c8bb9243331399d8"
    end

    resource "cubical" do
      url "https://github.com/agda/cubical/archive/refs/tags/v0.6.tar.gz"
      sha256 "10b78aec56c4dfa24a340852153e305306e6a569c49e75d1ba7edbaaa6bba8e3"
    end
  end

  bottle do
    sha256 arm64_sonoma:   "2b678bfe91131906fa2e43c95757967998966271ef2770ad8e5e03bf5a1eb0b0"
    sha256 arm64_ventura:  "b862f1ff03564076c13f590c6338326a3991acf2c3eb1fa9b5d9d20d5f99b32a"
    sha256 arm64_monterey: "7ae4cc4f53e325c43360d3c84fe53b2b7169e0adf005edc18e0c6f20663e8d4e"
    sha256 sonoma:         "793d4f2b0acf1ea386427691ba9b38501ceee869dea927fcf060d95bf13bd36c"
    sha256 ventura:        "1d6d106b1ed96914186734e84865fa990e12d51bafc195ac4661b141177cbc32"
    sha256 monterey:       "bfd05c56239a076dc1f621935e7130cd1bb4f08618b1f1285a9524495117d3dd"
    sha256 x86_64_linux:   "e938b07e2f672d1cc545bd6dbb23434684dbbad5e291362e641ad7cc67fc575d"
  end

  head do
    url "https://github.com/agda/agda.git", branch: "master"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib.git", branch: "master"
    end

    resource "cubical" do
      url "https://github.com/agda/cubical.git", branch: "master"
    end
  end

  depends_on "cabal-install"
  depends_on "emacs"
  depends_on "ghc"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "--store-dir=#{libexec}", "v2-install", *std_cabal_v2_args

    # generate the standard library's documentation and vim highlighting files
    agdalib = lib/"agda"
    resource("stdlib").stage agdalib
    cd agdalib do
      cabal_args = std_cabal_v2_args.reject { |s| s["installdir"] }
      system "cabal", "v2-update"
      system "cabal", "--store-dir=#{libexec}", "v2-install", *cabal_args, "--installdir=#{lib}/agda"
      system "./GenerateEverything"
      cd "doc" do
        system bin/"agda", "-i", "..", "--html", "--vim", "README.agda"
      end
    end

    # Clean up references to Homebrew shims
    rm_rf "#{agdalib}/dist-newstyle/cache"

    # generate the cubical library's documentation files
    cubicallib = agdalib/"cubical"
    resource("cubical").stage cubicallib
    cd cubicallib do
      system "make", "gen-everythings", "listings",
             "AGDA_BIN=#{bin/"agda"}",
             "RUNHASKELL=#{Formula["ghc"].bin/"runhaskell"}"
    end
  end

  test do
    simpletest = testpath/"SimpleTest.agda"
    simpletest.write <<~EOS
      module SimpleTest where

      data ℕ : Set where
        zero : ℕ
        suc  : ℕ → ℕ

      infixl 6 _+_
      _+_ : ℕ → ℕ → ℕ
      zero  + n = n
      suc m + n = suc (m + n)

      infix 4 _≡_
      data _≡_ {A : Set} (x : A) : A → Set where
        refl : x ≡ x

      cong : ∀ {A B : Set} (f : A → B) {x y} → x ≡ y → f x ≡ f y
      cong f refl = refl

      +-assoc : ∀ m n o → (m + n) + o ≡ m + (n + o)
      +-assoc zero    _ _ = refl
      +-assoc (suc m) n o = cong suc (+-assoc m n o)
    EOS

    stdlibtest = testpath/"StdlibTest.agda"
    stdlibtest.write <<~EOS
      module StdlibTest where

      open import Data.Nat
      open import Relation.Binary.PropositionalEquality

      +-assoc : ∀ m n o → (m + n) + o ≡ m + (n + o)
      +-assoc zero    _ _ = refl
      +-assoc (suc m) n o = cong suc (+-assoc m n o)
    EOS

    cubicaltest = testpath/"CubicalTest.agda"
    cubicaltest.write <<~EOS
      {-# OPTIONS --cubical #-}
      module CubicalTest where

      open import Cubical.Foundations.Prelude
      open import Cubical.Foundations.Isomorphism
      open import Cubical.Foundations.Univalence
      open import Cubical.Data.Int

      suc-equiv : ℤ ≡ ℤ
      suc-equiv = ua (isoToEquiv (iso sucℤ predℤ sucPred predSuc))
    EOS

    iotest = testpath/"IOTest.agda"
    iotest.write <<~EOS
      module IOTest where

      open import Agda.Builtin.IO
      open import Agda.Builtin.Unit

      postulate
        return : ∀ {A : Set} → A → IO A

      {-# COMPILE GHC return = \\_ -> return #-}

      main : _
      main = return tt
    EOS

    # we need a test-local copy of the stdlib as the test writes to
    # the stdlib directory; the same applies to the cubical library
    resource("stdlib").stage testpath/"lib/agda"
    resource("cubical").stage testpath/"lib/agda/cubical"

    # typecheck a simple module
    system bin/"agda", simpletest

    # typecheck a module that uses the standard library
    system bin/"agda", "-i", testpath/"lib/agda/src", stdlibtest

    # typecheck a module that uses the cubical library
    system bin/"agda", "-i", testpath/"lib/agda/cubical", cubicaltest

    # compile a simple module using the JS backend
    system bin/"agda", "--js", simpletest

    # test the GHC backend
    cabal_args = std_cabal_v2_args.reject { |s| s["installdir"] }
    system "cabal", "v2-update"
    system "cabal", "install", "--lib", "base"
    system "cabal", "v2-install", "ieee754", "--lib", *cabal_args
    system "cabal", "v2-install", "text", "--lib", *cabal_args

    # compile and run a simple program
    system bin/"agda", "--ghc-flag=-fno-warn-star-is-type", "-c", iotest
    assert_equal "", shell_output(testpath/"IOTest")
  end
end
