require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.10.1.tar.gz"
  sha256 "bd2ef929d9182920df395bbe5935d124ea62a4f4163d328549629da9bfdbb273"
  head "https://github.com/purescript/purescript.git"

  bottle do
    sha256 "81e6dda0abc029599046c5134c75191407534a4d94221e819c4d1166a133d57d" => :sierra
    sha256 "a417b2751aa49709496578d89a726f5b0c4cdb37a3329c470cb2122adb21004d" => :el_capitan
    sha256 "86171e3bdcfcf470afc0de150845a94abbc2de8c858f1d34e1342f6c79bc6112" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package :using => ["alex", "happy"]
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
