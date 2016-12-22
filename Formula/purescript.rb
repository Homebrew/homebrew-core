require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.10.3.tar.gz"
  sha256 "46c3f695ccc6e7be3cb2afe1ea9586eafdf51a04f1d40fe7240def0d8693ca68"
  head "https://github.com/purescript/purescript.git"

  bottle do
    sha256 "69ce4961c241c87adcd7f70445f8a8c2dd62d4d4bb96bc7ef85fb50b9c67b167" => :sierra
    sha256 "d1deef9286bf2587b4c279dfb59f751b0ab55bbf31febe12909763ac26ec2429" => :el_capitan
    sha256 "de3f5dbd405d1f1699b12b974d0f648594f93ae7793fade432469f03bf42b9ed" => :yosemite
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
