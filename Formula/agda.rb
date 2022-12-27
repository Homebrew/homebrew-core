class Agda < Formula
  desc "Dependently typed functional programming language"
  homepage "https://wiki.portal.chalmers.se/agda/"
  license "BSD-3-Clause"
  revision 3

  stable do
    url "https://hackage.haskell.org/package/Agda-2.6.2.2/Agda-2.6.2.2.tar.gz"
    sha256 "e5be3761717b144f64e760d8589ec6fdc0dda60d40125c49cdd48f54185c527a"

    # Use Hackage metadata revision to support GHC 9.4.
    # TODO: Remove this resource on next release along with corresponding install logic
    resource "Agda.cabal" do
      url "https://hackage.haskell.org/package/Agda-2.6.2.2/revision/2.cabal"
      sha256 "b69c2f317db2886cb387134af00a3e42a06fab6422686938797924d034255a55"
    end

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib/archive/v1.7.1.tar.gz"
      sha256 "6f92ae14664e5d1217e8366c647eb23ca88bc3724278f22dc6b80c23cace01df"

      # Backport upstream commits to support GHC 9.4.
      # TODO: Remove patches when updating resource to 1.7.2 or later
      # Ref: https://github.com/agda/agda-stdlib/commit/43c36399a8ca35e0bb2d99bf6359c931e5838990
      patch :DATA
      patch do
        url "https://github.com/agda/agda-stdlib/commit/81a924e41d24669a8935cc1b7168a96f0087ac21.patch?full_index=1"
        sha256 "8b84d751119a55db06bb88284a8e29a96cccea343cb5104e8eb38a1c22deac05"
      end
    end
  end

  bottle do
    sha256 arm64_ventura:  "13f390f73cc8566deef7e0cda118754858b75df3100e3b9dde94c6d87c6b5a3e"
    sha256 arm64_monterey: "efbb34a0ee23b6aa85ea3a7f1352e4d54a6b5981c9c4712e78555bc80037f39f"
    sha256 arm64_big_sur:  "d1315c0ec23b0344d52ed52b979e5021c9979da34bfd7da7353dd7030bcd9eae"
    sha256 ventura:        "bc71fe33bc97c42ebfd1e633025c6c3740d45db6c902d18431d32bfc9e040cf5"
    sha256 monterey:       "952364ac0a97c5537e31a4b1c840690683ef59f2ecd597dbea80ac736ad47ad8"
    sha256 big_sur:        "7feaf4300ea5480b2a5f32963ab9270e46727a28b5d6facdca6ef63f3addecd0"
    sha256 x86_64_linux:   "a8edb282b2b1778333251b332d4a7fd6f7da2a2e0f69783265717b057961a94c"
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
    resource("Agda.cabal").stage { buildpath.install "2.cabal" => "Agda.cabal" } unless build.head?

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

__END__
diff --git a/agda-stdlib-utils.cabal b/agda-stdlib-utils.cabal
index ceaabafdb..502bb3eb9 100644
--- a/agda-stdlib-utils.cabal
+++ b/agda-stdlib-utils.cabal
@@ -9,8 +9,9 @@ tested-with:     GHC == 8.0.2
                  GHC == 8.4.4
                  GHC == 8.6.5
                  GHC == 8.8.4
-                 GHC == 8.10.5
-                 GHC == 9.0.1
+                 GHC == 8.10.7
+                 GHC == 9.0.2
+                 GHC == 9.2.1

 executable GenerateEverything
   hs-source-dirs:   .
@@ -21,7 +22,7 @@ executable GenerateEverything
                     , directory >= 1.0.0.0 && < 1.4
                     , filemanip >= 0.3.6.2 && < 0.4
                     , filepath  >= 1.4.1.0 && < 1.5
-                    , mtl       >= 2.2.2   && < 2.3
+                    , mtl       >= 2.2.2   && < 2.4

 executable AllNonAsciiChars
   hs-source-dirs:   .
@@ -29,4 +30,4 @@ executable AllNonAsciiChars
   default-language: Haskell2010
   build-depends:      base      >= 4.9.0.0 && < 4.17
                     , filemanip >= 0.3.6.2 && < 0.4
-                    , text      >= 1.2.3.0 && < 1.3
+                    , text      >= 1.2.3.0 && < 2.1
