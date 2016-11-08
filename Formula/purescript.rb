require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.10.2.tar.gz"
  sha256 "4b5663e2a5ebb7a2e432f951d0a5d0ddfa08f18304827ec33f609d9b3c1c3fe7"
  head "https://github.com/purescript/purescript.git"

  bottle do
    sha256 "c9187e4c280bc7535b6a65392bdaa438435e3b39383faf0ec5d3eb4e488780e1" => :el_capitan_or_later
    sha256 "9fbb0bbca5cf06ba4b2a4df4df0410fedf4b0331087343b92a7123e91c2e4c9a" => :yosemite
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
