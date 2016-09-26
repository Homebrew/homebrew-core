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
    sha256 "28f48f10dba3d9065a7bcd4d245b7aef7a502796d630d05a339b3e1bfd82c3b0" => :sierra
    sha256 "a3d910d2e6496c498f464df931ca6385fb245c9b9a9f6b6a5a7b2272176e8910" => :el_capitan
    sha256 "ceef5225bc63048357300290ca28dfdaff4f35861ffb35045b14cb9b28d37d88" => :yosemite
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
