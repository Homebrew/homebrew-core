require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.10.7.tar.gz"
  sha256 "059c016dc4af550f1f39db55095488653795025d72023fdcbab366d0c4af704e"
  head "https://github.com/purescript/purescript.git"

  bottle do
    sha256 "eaf59ca3ed0a22aa3b0a98f870181f9f8616e3b075f2004f5544f4676fb8fd10" => :sierra
    sha256 "ddca04b5e79433357b6719119c1e9b59cb92c2f4a5b8433fc1eefcc0256d1c57" => :el_capitan
    sha256 "49bb89ad6e013d54bb8881f822ebdeedfd9c738d91759a2a3f4d05ba981feccf" => :yosemite
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
