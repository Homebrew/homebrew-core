require "language/haskell"

class Agda < Formula
  include Language::Haskell::Cabal

  desc "Dependently typed functional programming language"
  homepage "http://wiki.portal.chalmers.se/agda/"
  revision 1

  stable do
    url "https://hackage.haskell.org/package/Agda-2.5.1.2/Agda-2.5.1.2.tar.gz"
    sha256 "fb272bd6f7d532320c669b96faa85088b37bae02d906e9a9f764bc8e8639fb5e"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib/archive/v0.12.tar.gz"
      sha256 "2fddbc6d08e74c6205075704f40c550fc40137dee44e6b22b2e08ddee1410e87"
    end
  end

  bottle do
    sha256 "51217caa09ff9af054638d1c1081a684e5a567f40d7990295a73d8a772d51f69" => :sierra
    sha256 "8ad32ebc68923b448c416312ff350798276f732d0c1ed4eb55a63cc3cd51c148" => :el_capitan
    sha256 "265ee116d7ee9fa60b76551d444e9f4cd46c3c8c55a60c9f5716ad18ee219b17" => :yosemite
  end

  head do
    url "https://github.com/agda/agda.git"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib.git"
    end
  end

  deprecated_option "without-malonzo" => "without-ghc"

  option "without-stdlib", "Don't install the Agda standard library"
  option "without-ghc", "Disable the GHC backend"

  depends_on "ghc" => :recommended
  if build.with? "ghc"
    depends_on "cabal-install"
  else
    depends_on "ghc" => :build
    depends_on "cabal-install" => :build
  end

  depends_on :emacs => ["23.4", :recommended]

  def install
    # Remove for > 2.5.1.2
    # Equivalent to upstream commit from 17 Dec 2016
    # "[ #2319 ] Bumped directory upper version bound."
    # https://github.com/agda/agda/commit/2fb174551bdfb59fdd99a4d862810ee4f588c4cb
    if build.stable?
      inreplace "Agda.cabal", "directory >= 1.2.0.1 && < 1.3",
                              "directory >= 1.2.0.1 && < 1.4"
    end

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

    # run Agda's built-in test suite
    system bin/"agda", "--test"

    # typecheck a simple module
    system bin/"agda", simpletest

    # typecheck a module that uses the standard library
    if build.with? "stdlib"
      system bin/"agda", "-i", lib/"agda"/"src", stdlibtest
    end

    # compile a simple module using the JS backend
    system bin/"agda", "--js", simpletest

    # test the GHC backend
    if build.with? "ghc"
      cabal_sandbox do
        cabal_install "text"
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
