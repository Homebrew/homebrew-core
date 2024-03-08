class Agda < Formula
  desc "Dependently typed functional programming language"
  homepage "https://wiki.portal.chalmers.se/agda/"
  license "BSD-3-Clause"

  stable do
    url "https://hackage.haskell.org/package/Agda/Agda-2.6.4.3.tar.gz"
    sha256 "74edc96ec57d43bc148b329c02f6b06c3c3c16e8e40802e735570b1424df03a2"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib/archive/refs/tags/v2.0.tar.gz"
      sha256 "14eecb83d62495f701e1eb03ffba59a2f767491f728a8ab8c8bb9243331399d8"
    end

    resource "cubical" do
      url "https://github.com/agda/cubical/archive/refs/tags/v0.7.tar.gz"
      sha256 "25a0d1a0a01ba81888a74dfe864883547dbc1b06fa89ac842db13796b7389641"
    end

    resource "categories" do
      url "https://github.com/agda/agda-categories/archive/refs/tags/v0.2.0.tar.gz"
      sha256 "a4bf97bf0966ba81553a2dad32f6c9a38cd74b4c86f23f23f701b424549f9015"
    end

    resource "agda2hs" do
      url "https://github.com/agda/agda2hs/archive/refs/tags/v1.2.tar.gz"
      sha256 "e80ffc90ff2ccb3933bf89a39ab16d920a6c7a7461a6d182faa0fb6c0446dbb8"
    end
  end

  bottle do
    sha256 arm64_sonoma:   "813432ea01dc8df99f673bee3d2fedcc8464389d4d2103c869edff22d541077b"
    sha256 arm64_ventura:  "1912a6465375acb0a90289c2602ec42f48953a51c2417e71e36e6e50bd99e285"
    sha256 arm64_monterey: "db158ba0f428a024c378f5745098512d367846ee0743d58e1e8ef705a2ea4cd0"
    sha256 sonoma:         "41a85d6793aae7cfd06676d593bacab15f38136ae7073ccbc85cc26c032d0248"
    sha256 ventura:        "9265cb8532501a9c2b26d79284b4a8aebeede7742ec60fcbbde866d8613fff0c"
    sha256 monterey:       "2e1f341d01d10235c2811b0d67b552f1db5dbfaba45b999d3bb2a21fc041f855"
    sha256 x86_64_linux:   "4007f165143d5ff02b4eec59ae9604e7605f959831942bffe86ff79706546977"
  end

  head do
    url "https://github.com/agda/agda.git", branch: "master"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib.git", branch: "master"
    end

    resource "cubical" do
      url "https://github.com/agda/cubical.git", branch: "master"
    end

    resource "categories" do
      url "https://github.com/agda/agda-categories.git", branch: "master"
    end

    resource "agda2hs" do
      url "https://github.com/agda/agda2hs.git", branch: "master"
    end
  end

  depends_on "cabal-install"
  depends_on "emacs"
  depends_on "ghc"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    # expose certain packages for building and testing
    system "cabal", "--store-dir=#{libexec}", "v2-install",
           "base", "ieee754", "text", "directory", "--lib",
           *(std_cabal_v2_args.reject { |s| s["installdir"] })
    agdalib = lib/"agda"

    # install main Agda library and binaries
    system "cabal", "--store-dir=#{libexec}", "v2-install",
    "-foptimise-heavily", *std_cabal_v2_args

    # install agda2hs helper binary and library,
    # relying on the Agda library just installed
    resource("agda2hs").stage "agda2hs-build"
    cd "agda2hs-build" do
      system "cabal", "--store-dir=#{libexec}", "v2-install", *std_cabal_v2_args
    end

    # generate the standard library's documentation and vim highlighting files
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

    # Clean up references to Homebrew shims in the standard library
    rm_rf "#{agdalib}/dist-newstyle/cache"

    # generate the cubical library's documentation files
    cubicallib = agdalib/"cubical"
    resource("cubical").stage cubicallib
    cd cubicallib do
      system "make", "gen-everythings", "listings",
             "AGDA_BIN=#{bin/"agda"}",
             "RUNHASKELL=#{Formula["ghc"].bin/"runhaskell"}"
    end

    # generate the categories library's documentation files
    categorieslib = agdalib/"categories"
    resource("categories").stage categorieslib
    cd categorieslib do
      # fix the Makefile to use the Agda binary and
      # the standard library that we just installed
      inreplace "Makefile",
                "agda ${RTSARGS}",
                "#{bin}/agda --no-libraries -i #{agdalib}/src ${RTSARGS}"
      system "make", "html"
    end

    # move the agda2hs support library into place
    (agdalib/"agda2hs").install "agda2hs-build/lib",
                                "agda2hs-build/agda2hs.agda-lib"

    # write out the example libraries and defaults files for users to copy
    (agdalib/"example-libraries").write <<~EOS
      #{opt_lib}/agda/standard-library.agda-lib
      #{opt_lib}/agda/doc/standard-library-doc.agda-lib
      #{opt_lib}/agda/tests/standard-library-tests.agda-lib
      #{opt_lib}/agda/cubical/cubical.agda-lib
      #{opt_lib}/agda/categories/agda-categories.agda-lib
      #{opt_lib}/agda/agda2hs/agda2hs.agda-lib
    EOS
    (agdalib/"example-defaults").write <<~EOS
      standard-library
      cubical
      agda-categories
      agda2hs
    EOS
  end

  def caveats
    <<~EOS
      To use the installed Agda libraries, execute the following commands:

          mkdir -p $HOME/.config/agda
          cp #{opt_lib}/agda/example-libraries $HOME/.config/agda/libraries
          cp #{opt_lib}/agda/example-defaults $HOME/.config/agda/defaults

      You can then inspect the copied files and customize them as needed.
    EOS
  end

  test do
    simpletest = testpath/"SimpleTest.agda"
    simpletest.write <<~EOS
      {-# OPTIONS --safe --without-K #-}
      module SimpleTest where

      infix 4 _≡_
      data _≡_ {A : Set} (x : A) : A → Set where
        refl : x ≡ x

      cong : ∀ {A B : Set} (f : A → B) {x y} → x ≡ y → f x ≡ f y
      cong f refl = refl
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

    categoriestest = testpath/"CategoriesTest.agda"
    categoriestest.write <<~EOS
      module CategoriesTest where

      open import Level using (zero)
      open import Data.Empty
      open import Data.Quiver
      open Quiver

      empty-quiver : Quiver zero zero zero
      Obj empty-quiver = ⊥
      _⇒_ empty-quiver ()
      _≈_ empty-quiver {()}
      equiv empty-quiver {()}
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

    agda2hstest = testpath/"Agda2HsTest.agda"
    agda2hstest.write <<~EOS
      {-# OPTIONS --erasure #-}
      open import Haskell.Prelude

      _≤_ : {{Ord a}} → a → a → Set
      x ≤ y = (x <= y) ≡ True

      data BST (a : Set) {{@0 _ : Ord a}} (@0 lower upper : a) : Set where
        Leaf : (@0 pf : lower ≤ upper) → BST a lower upper
        Node : (x : a) (l : BST a lower x) (r : BST a x upper) → BST a lower upper

      {-# COMPILE AGDA2HS BST #-}
    EOS

    agda2hsout = testpath/"Agda2HsTest.hs"
    agda2hsexpect = <<~EOS
      module Agda2HsTest where

      data BST a = Leaf
                 | Node a (BST a) (BST a)

    EOS

    # we need a test-local copy of the stdlib as the test writes to
    # the stdlib directory; the same applies to the cubical,
    # categories, and agda2hs libraries
    resource("stdlib").stage testpath/"lib/agda"
    resource("cubical").stage testpath/"lib/agda/cubical"
    resource("categories").stage testpath/"lib/agda/categories"
    resource("agda2hs").stage testpath/"lib/agda/agda2hs"

    # typecheck a simple module
    system bin/"agda", simpletest

    # typecheck a module that uses the standard library
    system bin/"agda",
           "-i", testpath/"lib/agda/src",
           stdlibtest

    # typecheck a module that uses the cubical library
    system bin/"agda",
           "-i", testpath/"lib/agda/cubical",
           cubicaltest

    # typecheck a module that uses the categories library
    system bin/"agda",
           "-i", testpath/"lib/agda/categories/src",
           "-i", testpath/"lib/agda/src",
           categoriestest

    # compile a simple module using the JS backend
    system bin/"agda", "--js", simpletest

    # test the GHC backend;
    # compile and run a simple program
    system bin/"agda", "--ghc-flag=-fno-warn-star-is-type", "-c", iotest
    assert_equal "", shell_output(testpath/"IOTest")

    # translate a simple file via agda2hs
    system bin/"agda2hs", agda2hstest,
           "-i", testpath/"lib/agda/agda2hs/lib",
           "-o", testpath
    agda2hsactual = File.read(agda2hsout)
    assert_equal agda2hsexpect, agda2hsactual
  end
end
