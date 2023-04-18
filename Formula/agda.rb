class Agda < Formula
  desc "Dependently typed functional programming language"
  homepage "https://wiki.portal.chalmers.se/agda/"
  license "BSD-3-Clause"

  stable do
    url "https://hackage.haskell.org/package/Agda-2.6.3/Agda-2.6.3.tar.gz"
    sha256 "beacc9802c470e42bb0707f9ffe7db488a936c635407dada5d4db060b58d6016"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib/archive/v1.7.2.tar.gz"
      sha256 "d86a41b9d2e1d2e956ec91bdef9cb34646da11f50f76996761c9a1562c3c47a2"
    end
  end

  bottle do
    sha256 arm64_ventura:  "e6d794683df004cb540fc13038cb80378b7e5ee42fe8c20bd7c87cd7313606fe"
    sha256 arm64_monterey: "ef61f482507d2e0f89c2df9136f83fee454701c570f7834d60da72ec0f707264"
    sha256 arm64_big_sur:  "ccfb912d275052fb8d0a81ea3216e921c77f46cf0b2ec7b7dba5ef238f1868e1"
    sha256 ventura:        "5dbae0ce1b653e7dc099e234e137bb703dc8ded804d2785aaab3129440befb6d"
    sha256 monterey:       "afffee3246e21852bae17f1587a35a279fcdba0b87cda6fd8ed20c4166218a56"
    sha256 big_sur:        "e3a67f21d8e018dc4bb3ba17f08e1906125a7f2920b1e36a3af691cd1ad4f6ad"
    sha256 x86_64_linux:   "764d1eb2568588b1cb9a9e62dbc78e8caadd361424c2dde1b060f024cec399f9"
  end

  head do
    url "https://github.com/agda/agda.git", branch: "master"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib.git", branch: "master"
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
    resource("stdlib").stage lib/"agda"
    cd lib/"agda" do
      cabal_args = std_cabal_v2_args.reject { |s| s["installdir"] }
      system "cabal", "--store-dir=#{libexec}", "v2-install", *cabal_args, "--installdir=#{lib}/agda"
      system "./GenerateEverything"
      system bin/"agda", "-i", ".", "-i", "src", "--html", "--vim", "README.agda"
    end

    # Clean up references to Homebrew shims
    rm_rf "#{lib}/agda/dist-newstyle/cache"
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
    # the stdlib directory
    resource("stdlib").stage testpath/"lib/agda"

    # typecheck a simple module
    system bin/"agda", simpletest

    # typecheck a module that uses the standard library
    system bin/"agda", "-i", testpath/"lib/agda/src", stdlibtest

    # compile a simple module using the JS backend
    system bin/"agda", "--js", simpletest

    # test the GHC backend
    cabal_args = std_cabal_v2_args.reject { |s| s["installdir"] }
    system "cabal", "v2-update"
    system "cabal", "v2-install", "ieee754", "--lib", *cabal_args

    # compile and run a simple program
    system bin/"agda", "-c", iotest
    assert_equal "", shell_output(testpath/"IOTest")
  end
end
