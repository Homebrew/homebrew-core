class Agda < Formula
  desc "Dependently typed functional programming language"
  homepage "https://wiki.portal.chalmers.se/agda/"
  license "BSD-3-Clause"
  revision 1

  stable do
    url "https://hackage.haskell.org/package/Agda-2.6.3/Agda-2.6.3.tar.gz"
    sha256 "beacc9802c470e42bb0707f9ffe7db488a936c635407dada5d4db060b58d6016"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib/archive/v1.7.2.tar.gz"
      sha256 "d86a41b9d2e1d2e956ec91bdef9cb34646da11f50f76996761c9a1562c3c47a2"
    end

    # Use Hackage metadata revision to support GHC 9.6.
    # TODO: Remove this resource on next release along with corresponding install logic
    resource "cabal-install.cabal" do
      url "https://hackage.haskell.org/package/Agda-2.6.3/revision/4.cabal"
      sha256 "908b41a77d70c723177ff6d4e2be22ef7c89d22587d4747792aac07215b1d0f5"
    end

    # Use Hackage metadata revision to support GHC 9.6.
    # TODO: Remove this resource on next release along with corresponding install logic
    resource "agda-stdlib-utils.cabal" do
      url "https://raw.githubusercontent.com/agda/agda-stdlib/fe151ddebedafe80c358bfc1fbcf3cea42a58db7/agda-stdlib-utils.cabal"
      sha256 "91be962de76b0d9a06d5286afdb13b3738aef1f7d7f6feb58ac55594a86c1394"
    end
  end

  bottle do
    sha256 arm64_sonoma:   "30f144a088df8c6bb65bf14830225a1811a7f22326cdf8c634246c629b04ce31"
    sha256 arm64_ventura:  "038df1f870f8656883676192ae703a2cd6671101f9c558607e65ce23ad7cfd98"
    sha256 arm64_monterey: "ee9490269364d3ff10a764a1f1187184ecec77aee911b2e4afaa6698c2829ceb"
    sha256 ventura:        "10a7682c89f37b23b61a13eb09cb9910cce9882848c11ca4f1616b063aefe9ab"
    sha256 monterey:       "c62f5185a1093e13f48694a65b4f381ceca27fcb2c060823a644d6be72e21498"
    sha256 x86_64_linux:   "ac97a785c4e9b05bc6dc845437fafd0c2a30cb9a405823da877193de1a2a3110"
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
    resource("cabal-install.cabal").stage { buildpath.install "4.cabal" => "Agda.cabal" } unless build.head?
    system "cabal", "v2-update"
    system "cabal", "--store-dir=#{libexec}", "v2-install", *std_cabal_v2_args

    # generate the standard library's documentation and vim highlighting files
    agdalib = lib/"agda"
    resource("stdlib").stage agdalib
    cd agdalib do
      cabal_args = std_cabal_v2_args.reject { |s| s["installdir"] }
      unless build.head?
        resource("agda-stdlib-utils.cabal").stage do
          agdalib.install "agda-stdlib-utils.cabal" => "agda-stdlib-utils.cabal"
        end
      end
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
