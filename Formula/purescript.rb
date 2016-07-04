require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.9.1.tar.gz"
  sha256 "ae5f565c1a5ce04cb3bb972be33855d2b932a1866fd8c21eb1f714692b951abc"
  head "https://github.com/purescript/purescript.git"

  bottle do
    sha256 "d8f5810d035e8db2c9a04290aae5630818170f8596816f05686ca8fca7e2dba2" => :el_capitan
    sha256 "7fef274f04be784ccd6459eb6b781a817575d8d96052f0497c04bce18b5ed598" => :yosemite
    sha256 "eb7bd9461fba4704d58febfe340b9a2e98dfa8e34beab92d2616367d55b2e7d1" => :mavericks
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
