class Agda < Formula
  desc "Dependently typed functional programming language"
  homepage "https://wiki.portal.chalmers.se/agda/"
  license "BSD-3-Clause"
  revision 3

  stable do
    url "https://hackage.haskell.org/package/Agda-2.6.2/Agda-2.6.2.tar.gz"
    sha256 "072caaad7a405b764423958d2001b68fbfd3fc8f98870cd0a5f0bcaeadfd3095"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib/archive/v1.7.tar.gz"
      sha256 "180302df8bdd01fd404ae5ee217d4c04376fcfbab2b70958a87109df531e299d"
    end
  end

  bottle do
    sha256 arm64_monterey: "55cdf17997c733ff0ae3016e2d57f44cb88236d8d6a9d5a20c82be88b74d7f51"
    sha256 arm64_big_sur:  "3b5eae987128fc6e4e4b0b12a62090fc09fea5c1c1154c352cb2c30f11675cda"
    sha256 monterey:       "2ba3ec42d514b8076415b3193f01ef73471be8a9ed4bd29ad3948c10d568436f"
    sha256 big_sur:        "3a61aafe0161b54464aa9fb51a3f32815580eb265d70a41c90167e76f6755f1e"
    sha256 catalina:       "93124085f0bd4fc9e84bf162e308523f37cda6252660f9804e746ea4ed2d02cd"
    sha256 x86_64_linux:   "510a98c8671655ae944de5f74b06507bad58e13c1e0fe81609432197e944008d"
  end

  head do
    url "https://github.com/agda/agda.git"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib.git"
    end
  end

  depends_on "cabal-install"
  depends_on "emacs"
  depends_on "ghc"

  uses_from_macos "zlib"

  resource "alex" do
    url "https://hackage.haskell.org/package/alex-3.2.6/alex-3.2.6.tar.gz"
    sha256 "91aa08c1d3312125fbf4284815189299bbb0be34421ab963b1f2ae06eccc5410"
  end

  resource "cpphs" do
    url "https://hackage.haskell.org/package/cpphs-1.20.9.1/cpphs-1.20.9.1.tar.gz"
    sha256 "7f59b10bc3374004cee3c04fa4ee4a1b90d0dca84a3d0e436d5861a1aa3b919f"
  end

  resource "happy" do
    url "https://hackage.haskell.org/package/happy-1.20.0/happy-1.20.0.tar.gz"
    sha256 "3b1d3a8f93a2723b554d9f07b2cd136be1a7b2fcab1855b12b7aab5cbac8868c"
  end

  def install
    ENV["CABAL_DIR"] = prefix/"cabal"
    system "cabal", "v2-update"
    cabal_args = std_cabal_v2_args.reject { |s| s["installdir"] }

    # happy must be installed before alex
    %w[happy alex cpphs].each do |r|
      r_installdir = libexec/r/"bin"
      ENV.prepend_path "PATH", r_installdir

      resource(r).stage do
        mkdir r_installdir
        system "cabal", "v2-install", *cabal_args, "--installdir=#{r_installdir}"
      end
    end

    system "cabal", "v2-install", "-f", "cpphs", *std_cabal_v2_args

    # generate the standard library's documentation and vim highlighting files
    resource("stdlib").stage lib/"agda"
    cd lib/"agda" do
      system "cabal", "v2-install", *cabal_args, "--installdir=#{lib}/agda"
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
