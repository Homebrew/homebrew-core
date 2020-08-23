require "language/haskell"

class Agda < Formula
  include Language::Haskell::Cabal

  desc "Dependently typed functional programming language"
  homepage "https://wiki.portal.chalmers.se/agda/"
  license "BSD-3-Clause"

  stable do
    url "https://hackage.haskell.org/package/Agda-2.6.1/Agda-2.6.1.tar.gz"
    sha256 "678f416af8f30d017825309f15fac41d239b07f66a4c40497e8435a6bdb7c129"

    resource "stdlib" do
      # version needed to build with ghc-8.10.1
      url "https://github.com/agda/agda-stdlib.git",
          revision: "b859bd363a96bc862ead0509bdf5869837651896"
    end
  end

  bottle do
    rebuild 1
    sha256 "a7a95a514b445fcb561ac0ed5be267327c111507f367add5d726c0a6b96afa7b" => :catalina
    sha256 "b617423569007baea1876abe6c34f4c5524ad050a8c93185f815f62e968d1750" => :mojave
    sha256 "7808d30de9683ed16057e9c5508587db60e7fbcd5a7d7674afc51016c5f68327" => :high_sierra
  end

  head do
    url "https://github.com/agda/agda.git"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib.git"
    end
  end

  depends_on "cabal-install"
  depends_on "emacs"
  depends_on "ghc@8.8"

  uses_from_macos "zlib"

  def install
    # install Agda core
    install_cabal_package using: ["alex", "happy", "cpphs"]

    resource("stdlib").stage lib/"agda"

    # generate the standard library's bytecode
    cd lib/"agda" do
      cabal_sandbox home: buildpath, keep_lib: true do
        cabal_install "--only-dependencies"
        cabal_install
        system "GenerateEverything"
      end
    end

    # generate the standard library's documentation and vim highlighting files
    cd lib/"agda" do
      system bin/"agda", "-i", ".", "-i", "src", "--html", "--vim", "README.agda"
    end

    # compile the included Emacs mode
    system bin/"agda-mode", "compile"
    elisp.install_symlink Dir["#{share}/*/Agda-#{version}/emacs-mode/*"]
  end

  def caveats
    <<~EOS
      To use the Agda standard library by default:
        mkdir -p ~/.agda
        echo #{HOMEBREW_PREFIX}/lib/agda/standard-library.agda-lib >>~/.agda/libraries
        echo standard-library >>~/.agda/defaults
    EOS
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

    stdlibiotest = testpath/"StdlibIOTest.agda"
    stdlibiotest.write <<~EOS
      module StdlibIOTest where

      open import IO

      main : _
      main = run (putStr "Hello, world!")
    EOS

    # typecheck a simple module
    system bin/"agda", simpletest

    # typecheck a module that uses the standard library
    system bin/"agda", "-i", lib/"agda"/"src", stdlibtest

    # compile a simple module using the JS backend
    system bin/"agda", "--js", simpletest

    # test the GHC backend
    cabal_sandbox do
      cabal_install "ieee754"
      dbpath = Dir["#{testpath}/.cabal-sandbox/*-packages.conf.d"].first
      dbopt = "--ghc-flag=-package-db=#{dbpath}"

      # compile and run a simple program
      system bin/"agda", "-c", dbopt, iotest
      assert_equal "", shell_output(testpath/"IOTest")

      # compile and run a program that uses the standard library
      system bin/"agda", "-c", "-i", lib/"agda"/"src", dbopt, stdlibiotest
      assert_equal "Hello, world!", shell_output(testpath/"StdlibIOTest")
    end
  end
end
