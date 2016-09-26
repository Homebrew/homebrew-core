require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  revision 1

  head "https://github.com/purescript/purescript.git"

  stable do
    url "https://github.com/purescript/purescript/archive/v0.9.3.tar.gz"
    sha256 "70ea9ea189300e8ce7ea89eec818a1c9e39be1e758638898b936028fc0155783"

    # Remove when 0.10.0 is released; fix "Variable not in scope" errors
    # Adds compatibility with optparse-applicative 0.13.0.0
    # Upstream PR was https://github.com/purescript/purescript/pull/2278
    # Same as upstream commit https://github.com/purescript/purescript/commit/bdbf4e2
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/7a5ebb6/purescript/purescript-optparse-applicative.patch"
      sha256 "22967efbda6cca1dcae6898d848160bff57112e229fc2a87642f5180089b5feb"
    end
  end

  bottle do
    sha256 "7493c36c9072080361e7c4e894fbc3b6207a41e28f916bbf832c45af17a9acd5" => :el_capitan
    sha256 "0de9573c7822f266ac6ef4bfdd67c42c34dea0647bf9f7c00b1a2dea0f54c7a0" => :yosemite
    sha256 "56219c3380d978226a1d7291352b9fba92b46d14c50414a4143ffce0235bfbd7" => :mavericks
  end

  devel do
    url "https://github.com/purescript/purescript/archive/v0.10.0-rc.1.tar.gz"
    version "0.10.0-rc1"
    sha256 "bd0cbcedad882dc66fec5d71b8870d3efdb31bcbe82d682e405454b1f3b2a9e9"
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
