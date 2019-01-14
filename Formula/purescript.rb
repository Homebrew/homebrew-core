require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://hackage.haskell.org/package/purescript-0.12.1/purescript-0.12.1.tar.gz"
  sha256 "81ab67e994a85e4ee455d35a5023b5ee2f191c83e9de2be65a8cd2892e302454"
  head "https://github.com/purescript/purescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d93184292a93f8b9b7f142b949bf8d6b4c32cbb2cc61b531cee3ae1c11f1d36" => :mojave
    sha256 "1c9541e29396f4779653874705b70081d1b7ecbfd03504c075d6592eac1a64b7" => :high_sierra
    sha256 "d22668820085862153e81213b2e127b9162b6ea337aaa6c09b3b988e33f3a49c" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    cabal_sandbox do
      if build.head?
        cabal_install "hpack"
        system "./.cabal-sandbox/bin/hpack"
      end

      install_cabal_package "-f", "release", :using => ["alex", "happy"]
    end
  end

  test do
    test_module_path = testpath/"Test.purs"
    test_target_path = testpath/"test-module.js"
    test_module_path.write <<~EOS
      module Test where

      main :: Int
      main = 1
    EOS
    system bin/"purs", "compile", test_module_path, "-o", test_target_path
    assert_predicate test_target_path, :exist?
  end
end
