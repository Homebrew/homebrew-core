require "language/haskell"

class Agda < Formula
  include Language::Haskell::Cabal

  desc "Dependently typed functional programming language"
  homepage "https://wiki.portal.chalmers.se/agda/"

  stable do
    url "https://hackage.haskell.org/package/Agda-2.5.4.2/Agda-2.5.4.2.tar.gz"
    sha256 "f645add8a47a35da3f37757204fa9c80aeb0993d628fc2057fa343e92e579b1f"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib.git",
          :tag      => "v0.17",
          :revision => "5819a4dd9c965296224944f05b1481805649bdc2"
    end
  end

  bottle do
    rebuild 1
    sha256 "eef42265827b82744ad2b9d6238fa4d8984d226251fb54825734f300a40faa98" => :mojave
    sha256 "74b627b7b04489c7ea610fada9df16d3a6f3e5926a6ee40f3032f93e67382b44" => :high_sierra
    sha256 "b8d0a4cd285ee27406e9dc673d03b6c0bb34604c72919b8059826a7c84b7c547" => :sierra
  end

  head do
    url "https://github.com/agda/agda.git"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib.git"
    end
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "emacs"
  depends_on "ghc"

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
    system bin/"agda-mode", "compile"
    elisp.install_symlink Dir["#{share}/*/Agda-#{version}/emacs-mode/*"]
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
