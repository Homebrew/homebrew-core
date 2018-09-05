require "language/haskell"

class Agda < Formula
  include Language::Haskell::Cabal

  desc "Dependently typed functional programming language"
  homepage "http://wiki.portal.chalmers.se/agda/"

  stable do
    url "https://hackage.haskell.org/package/Agda-2.5.4.1/Agda-2.5.4.1.tar.gz"
    sha256 "7759aa76936e6a35325c2e186a7546553921775155a426c8edc9a234f58ab72f"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib.git",
          :revision => "a1a10b39d35b8fc40e87723a89f5682252d46380"
    end
  end

  bottle do
    sha256 "ff07f75efd1934c0b729a2130bf55ce2c3a50eb8462998a4e905852f9215dca8" => :mojave
    sha256 "a040cb1a273037a0ed2983be3c7ccddf8c606e762e976f22da5b7c89a7c5ae8a" => :high_sierra
    sha256 "b097269cfd028fae6bf73db2eccb41e253d4962340ae962e104196e36868985b" => :sierra
    sha256 "8b189b0fa2e7c2332d9ca1239c21f0dca0df714f59eb2fd5dd5e0483f33bd90a" => :el_capitan
  end

  head do
    url "https://github.com/agda/agda.git"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib.git"
    end
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc"
  depends_on "emacs" => :recommended

  def install
    # install Agda core
    install_cabal_package :using => ["alex", "happy", "cpphs"]

    resource("stdlib").stage lib/"agda"

    # generate the standard library's bytecode
    cd lib/"agda" do
      cabal_sandbox :home => buildpath, :keep_lib => true do
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
    if build.with? "emacs"
      system bin/"agda-mode", "compile"
      elisp.install_symlink Dir["#{share}/*/Agda-#{version}/emacs-mode/*"]
    end
  end

  def caveats; <<~EOS
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

      {-# COMPILED return (\\_ -> return) #-}

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
      cabal_install "text", "ieee754"
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
