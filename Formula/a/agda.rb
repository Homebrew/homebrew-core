class Agda < Formula
  desc "Dependently typed functional programming language"
  homepage "https://wiki.portal.chalmers.se/agda/"
  # agda2hs.cabal specifies BSD-3-Clause but it installs an MIT LICENSE file.
  # Everything else specifies MIT license and installs corresponding file.
  license all_of: ["MIT", "BSD-3-Clause"]
  revision 2

  stable do
    url "https://github.com/agda/agda/archive/refs/tags/v2.6.4.3-r1.tar.gz"
    sha256 "15a0ebf08b71ebda0510c8cad04b053beeec653ed26e2c537614a80de8b2e132"
    version "2.6.4.3"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib/archive/refs/tags/v2.1.tar.gz"
      sha256 "72ca3ea25094efa0439e106f0d949330414232ec4cc5c3c3316e7e70dd06d431"
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

  # The regex below is intended to match stable tags like `2.6.3` but not
  # seemingly unstable tags like `2.6.3.20230930`.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*\.\d{1,3})$/i)
  end

  bottle do
    sha256 arm64_sequoia:  "efcb6bc585745b2967257a989c96dc870b7e42e8605c36594e0ee204e4b71302"
    sha256 arm64_sonoma:   "37754c8fe159f96685467a321a30c35c7088c2fa7a5bf9912ba67c972d79399b"
    sha256 arm64_ventura:  "34042e188e7e31f2c6dbc1596499524f25418d6336484820851f023245133e8d"
    sha256 arm64_monterey: "d8b64716f20cd7037b6c3bc099b4260cd76d15404a6ace0ffa71313f8cf8a332"
    sha256 sonoma:         "6aff1192bdc412c72806011171db6e07a3f8f5bcc389f8bb23924810fef15bfd"
    sha256 ventura:        "341696bc1ea2218202bed2823be2ab56d75410570b25b83274958f63ca463939"
    sha256 monterey:       "2a81118ecccc5e080caf92f85426a81eda64df40378fc6a1eca0e27e9fac6ddc"
    sha256 x86_64_linux:   "921f03e6fc741c7be27df3982e9254214688fc9e9e51722950d327ae8d427f5d"
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
    cabal_args = std_cabal_v2_args.reject { |s| s["installdir"] }

    system "cabal", "v2-update"
    # expose certain packages for building and testing
    system "cabal", "--store-dir=#{libexec}", "v2-install",
           "base", "ieee754", "text", "directory", "--lib",
           *cabal_args
    agdalib = lib/"agda"

    # install main Agda library and binaries
    system "cabal", "--store-dir=#{libexec}", "v2-install",
    "-foptimise-heavily", *std_cabal_v2_args

    # install agda2hs helper binary and library,
    # relying on the Agda library just installed
    resource("agda2hs").stage "agda2hs-build"
    cd "agda2hs-build" do
      # Use previously built Agda binary to work around build error with Cabal 3.12
      # Issue ref: https://github.com/agda/agda/issues/7401
      # TODO: Try removing workaround when Agda 2.7.0 is released
      if build.stable?
        odie "Try to remove Setup.hs workaround!" if version > "2.6.4.3"
        Pathname("cabal.project.local").write "packages: ./agda2hs.cabal ../Agda.cabal"
        inreplace buildpath/"Setup.hs", ' agda = bdir </> "agda" </> "agda" <.> agdaExeExtension',
                                        " agda = \"#{bin}/agda\" <.> agdaExeExtension"
      end

      # Work around to build agda2hs with GHC 9.10
      # Issue ref: https://github.com/agda/agda2hs/issues/347
      inreplace "agda2hs.cabal", /( base .*&&) < 4\.20,/, "\\1 < 4.21,", build.stable?

      system "cabal", "--store-dir=#{libexec}", "v2-install", *std_cabal_v2_args
    end

    # generate the standard library's documentation and vim highlighting files
    resource("stdlib").stage agdalib
    cd agdalib do
      system "cabal", "--store-dir=#{libexec}", "v2-install", *cabal_args, "--installdir=#{lib}/agda"
      system "./GenerateEverything"
      cd "doc" do
        system bin/"agda", "-i", "..", "--html", "--vim", "README.agda"
      end
    end

    # Clean up references to Homebrew shims in the standard library
    rm_r("#{agdalib}/dist-newstyle/cache")

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
