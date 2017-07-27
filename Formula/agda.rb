require "language/haskell"

class Agda < Formula
  include Language::Haskell::Cabal

  desc "Dependently typed functional programming language"
  homepage "http://wiki.portal.chalmers.se/agda/"
  revision 1

  stable do
    url "https://hackage.haskell.org/package/Agda-2.5.2/Agda-2.5.2.tar.gz"
    sha256 "d812cec3bf7f03c4b27248572475c7e060154102771a8434cc11ba89f5691439"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib/archive/v0.13.tar.gz"
      sha256 "e7cffc2b8b168c3584b6d1e760d2b49850835444e4777caa69eb29b3677ef8bb"
    end
  end

  bottle do
    sha256 "195d08c2ee4b0b415443df8d9cbcbb383e9ed39e5a62cba4c4cdd537bc4cb93e" => :sierra
    sha256 "9af94e36d57ff4d07430ff375d56f594fde7289085f708ab349181a02df82571" => :el_capitan
    sha256 "9711ee243f0ccfb7e2a3226b9e3f2cb91f678ea619ada7dd36e6f1158ba54772" => :yosemite
  end

  head do
    url "https://github.com/agda/agda.git"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib.git"
    end
  end

  deprecated_option "without-malonzo" => "without-ghc@8.0"
  deprecated_option "without-ghc" => "without-ghc@8.0"

  option "without-stdlib", "Don't install the Agda standard library"
  option "without-ghc@8.0", "Disable the GHC backend"

  depends_on "ghc@8.0" => :recommended
  if build.with? "ghc@8.0"
    depends_on "cabal-install"
  else
    depends_on "ghc@8.0" => :build
    depends_on "cabal-install" => :build
  end

  depends_on :emacs => ["23.4", :recommended]

  def install
    # install Agda core
    install_cabal_package :using => ["alex", "happy", "cpphs"]

    if build.with? "stdlib"
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
    end

    # compile the included Emacs mode
    if build.with? "emacs"
      system bin/"agda-mode", "compile"
      elisp.install_symlink Dir["#{share}/*/Agda-#{version}/emacs-mode/*"]
    end
  end

  def caveats
    s = ""

    if build.with? "stdlib"
      s += <<-EOS.undent
      To use the Agda standard library by default:
        mkdir -p ~/.agda
        echo #{HOMEBREW_PREFIX}/lib/agda/standard-library.agda-lib >>~/.agda/libraries
        echo standard-library >>~/.agda/defaults
      EOS
    end

    s
  end

  test do
    simpletest = testpath/"SimpleTest.agda"
    simpletest.write <<-EOS.undent
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
    stdlibtest.write <<-EOS.undent
      module StdlibTest where

      open import Data.Nat
      open import Relation.Binary.PropositionalEquality

      +-assoc : ∀ m n o → (m + n) + o ≡ m + (n + o)
      +-assoc zero    _ _ = refl
      +-assoc (suc m) n o = cong suc (+-assoc m n o)
    EOS

    iotest = testpath/"IOTest.agda"
    iotest.write <<-EOS.undent
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
    stdlibiotest.write <<-EOS.undent
      module StdlibIOTest where

      open import IO

      main : _
      main = run (putStr "Hello, world!")
    EOS

    # typecheck a simple module
    system bin/"agda", simpletest

    # typecheck a module that uses the standard library
    if build.with? "stdlib"
      system bin/"agda", "-i", lib/"agda"/"src", stdlibtest
    end

    # compile a simple module using the JS backend
    system bin/"agda", "--js", simpletest

    # test the GHC backend
    if build.with? "ghc@8.0"
      ENV.prepend_path "PATH", Formula["ghc@8.0"].opt_bin
      cabal_sandbox do
        cabal_install "text", "ieee754"
        dbpath = Dir["#{testpath}/.cabal-sandbox/*-packages.conf.d"].first
        dbopt = "--ghc-flag=-package-db=#{dbpath}"

        # compile and run a simple program
        system bin/"agda", "-c", dbopt, iotest
        assert_equal "", shell_output(testpath/"IOTest")

        # compile and run a program that uses the standard library
        if build.with? "stdlib"
          system bin/"agda", "-c", "-i", lib/"agda"/"src", dbopt, stdlibiotest
          assert_equal "Hello, world!", shell_output(testpath/"StdlibIOTest")
        end
      end
    end
  end
end
