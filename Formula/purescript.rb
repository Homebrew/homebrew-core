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
    sha256 "17e39417b41f7cf0e06d2e3a29c5e975fe965ff5a3a308a136fbe8f315d69638" => :mojave
    sha256 "62993220922b38d614fdbf466e8de97f4f367ce74d36e2365c7d45ed2ba993cb" => :high_sierra
    sha256 "0fb283a25fa3a1af5281a94d99a4f0c32ad1687c27f0628ecb75873b1e4e6ed4" => :sierra
    sha256 "805f8c9922de1390c63ddd1073d6ebc3ad61c4f658906ef42f4dfa680cc9e575" => :el_capitan
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
