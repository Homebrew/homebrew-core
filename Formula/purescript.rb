require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.11.1.tar.gz"
  sha256 "0faa3e814c11eab064bfa5fe37215441872fc502e0ce531bbcf8e55170614994"
  head "https://github.com/purescript/purescript.git"

  bottle do
    sha256 "8297e49bd764dce5a2a403685e4efafca4ea0dbe8d544aa9f2d95a586995e9ba" => :sierra
    sha256 "ad7cff338158226eaa8196921b86f2b494b8a92a6060726bc8a0e3e22c51ae61" => :el_capitan
    sha256 "b3eff0f81885bf12386735d6090f7c44143966c1bf9da22d82bd090582051c50" => :yosemite
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
