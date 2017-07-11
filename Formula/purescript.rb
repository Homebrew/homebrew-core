require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.11.6.tar.gz"
  sha256 "8bd2e4f844666a553d93c2e55c72c6361fbc08c706157d9d975dc7c1b730304e"
  head "https://github.com/purescript/purescript.git"

  bottle do
    sha256 "1dbab5a06ca169ffd6fdfe5e64b08384e6824eb1a39d7cd08800c0c247781a0e" => :sierra
    sha256 "9a4e1906432ce371da04a67ef5a82c1cab21a7fd5d6bb3eb49254054dd812866" => :el_capitan
    sha256 "7652c5d27d1d1380dd73de9672bcba4ff1553616080fe94b3a111b1023548627" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    inreplace (buildpath/"scripts").children, /^purs /, "#{bin}/purs "
    bin.install (buildpath/"scripts").children

    cabal_sandbox do
      if build.head?
        cabal_install "hpack"
        system "./.cabal-sandbox/bin/hpack"
      else
        system "cabal", "get", "purescript-#{version}"
        mv "purescript-#{version}/purescript.cabal", "."
      end
      install_cabal_package :using => ["alex", "happy"]
    end
  end

  test do
    test_module_path = testpath/"Test.purs"
    test_target_path = testpath/"test-module.js"
    test_module_path.write <<-EOS.undent
      module Test where

      main :: Int
      main = 1
    EOS
    system bin/"psc", test_module_path, "-o", test_target_path
    assert File.exist?(test_target_path)
  end
end
