require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.10.3.tar.gz"
  sha256 "46c3f695ccc6e7be3cb2afe1ea9586eafdf51a04f1d40fe7240def0d8693ca68"
  head "https://github.com/purescript/purescript.git"

  bottle do
    rebuild 1
    sha256 "9061f02205436efeedb0350cec40f81aeb1c714bf3be6ec1ffa2d23a9036cf7b" => :sierra
    sha256 "3d20149072a5c931af2f8d7f7c909c354bcf6babceb786c5660775bdfe28341c" => :el_capitan
    sha256 "549f565313ff57b8bf4b1b7ef7dd07771d3501b24945b25f1ff8bcad20a15b00" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    # Fix "error: Couldn't match type 'Text' with 'Line'"
    # Upstream issue "turtle 1.3 breaks build"
    # Reported 10 Dec 2016 https://github.com/purescript/purescript/issues/2472
    inreplace "purescript.cabal", "turtle -any", "turtle < 1.3"

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
