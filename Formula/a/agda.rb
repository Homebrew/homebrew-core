class Agda < Formula
  desc "Dependently typed functional programming language"
  homepage "https://wiki.portal.chalmers.se/agda/"
  license "BSD-3-Clause"

  stable do
    url "https://hackage.haskell.org/package/Agda-2.6.4/Agda-2.6.4.tar.gz"
    sha256 "5b2cbc719157fadcf32f9a8d1915c360c5a5328c34745f15a7c49d71b6f5ef4b"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib/archive/v1.7.3.tar.gz"
      sha256 "91c42323fdc94d032a8c98ea9249d9d77e7ba3b51749fe85f18536dbbe603437"
    end
  end

  bottle do
    sha256 arm64_sonoma:   "4448f766b6f8720480dd91343419fb729bf4b31d7e159db8c5875a6bc207ea26"
    sha256 arm64_ventura:  "603697a77734602555b817b4528259d81d01e2657a5a769e31f0e5769ef3eef9"
    sha256 arm64_monterey: "7707123f1f59194d559b8c35ae83c384347942f9e83fd000dada13c9c5cf677e"
    sha256 sonoma:         "9f1a5b0e6d1988b7083177edadbed26c75837567441e04bd9e315df2018a2a31"
    sha256 ventura:        "348f958cbeae5aad1eae9801d68932ead52cf4b8e2d1c050007c09aab4720b29"
    sha256 monterey:       "570bb10e098deac4fdece09d402862b8fa64cfe9439ee9dba8842c39e711ef64"
    sha256 x86_64_linux:   "b0059840d871280b216d5bab6155ba2124e09acce611eb8b1480307197904e6c"
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
    agdalib = lib/"agda"
    resource("stdlib").stage agdalib
    cd agdalib do
      cabal_args = std_cabal_v2_args.reject { |s| s["installdir"] }
      system "cabal", "v2-update"
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
    system "cabal", "install", "--lib", "base"
    system "cabal", "v2-install", "ieee754", "--lib", *cabal_args
    system "cabal", "v2-install", "text", "--lib", *cabal_args

    # compile and run a simple program
    system bin/"agda", "--ghc-flag=-fno-warn-star-is-type", "-c", iotest
    assert_equal "", shell_output(testpath/"IOTest")
  end
end
