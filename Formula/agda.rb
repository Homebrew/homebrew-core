class Agda < Formula
  desc "Dependently typed functional programming language"
  homepage "https://wiki.portal.chalmers.se/agda/"
  license "BSD-3-Clause"
  revision 2

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
    sha256 arm64_monterey: "075fb9d1c1d3bb2ce9786958aad1c166c207e042c257422fed60fb7b56f6cd48"
    sha256 arm64_big_sur:  "2db89fc4cfb9bc3b3676c042ca42dff4c7991b70ae42a5e370cd323487fed5d0"
    sha256 ventura:        "0b37ca6a111814a20b4ace1022cdeb43eed65fee44c4f4e2360b1a46e923dd9b"
    sha256 monterey:       "e1d3778a1e0293edba2759e000fc7ee8cc2bda1042255c0a02d176b15c6653ce"
    sha256 big_sur:        "c40f2ab5942348b945ca36cba679f0d55dfcdf14fa3d048e4712d450687ab9e5"
    sha256 catalina:       "66e344fc29367ea27a055218f1cedb66019849c58110711409fdd52f38a839e2"
    sha256 x86_64_linux:   "4742399788dd43bb888c31f95e176be233c2569d8999191f69902179509fac8a"
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
