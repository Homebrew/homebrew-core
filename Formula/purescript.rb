require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.11.1.tar.gz"
  sha256 "0faa3e814c11eab064bfa5fe37215441872fc502e0ce531bbcf8e55170614994"
  head "https://github.com/purescript/purescript.git"

  bottle do
    sha256 "37b4cf978d9c00db5ef03501f5f773906f0a08f992a992ad7e0b94dbb33db524" => :sierra
    sha256 "edeeb39297a6cfadebb814fb1f58ca287382b11976fe3eb2f0d3c41de6406f87" => :el_capitan
    sha256 "ed00ab7968209ccf458ff4c16ce2a7a9ef7f005addb3decadc5205ebdc8c3173" => :yosemite
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
    system bin/"purs", "compile", test_module_path, "-o", test_target_path
    assert File.exist?(test_target_path)
  end
end
