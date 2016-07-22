require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.9.2.tar.gz"
  sha256 "f02e5b39764346aa83103ef40cfd90e5aeea6958793ec64ab0eac37293b8df2f"
  head "https://github.com/purescript/purescript.git"

  bottle do
    sha256 "9e77153298a0c2d1cf511701cfdf3a7404eaefcd9865ea56d688dffdf1a4e8c7" => :el_capitan
    sha256 "ddd0da77eeef694476183ea1b8302b50da47609283166ff39c2301ed72f4b800" => :yosemite
    sha256 "bfb298f60105ec78f4bfaf904311f29135ea76b405950d5de0aa4db00be179c6" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    # "ambiguous occurrence" errors for fromStrict, decodeUtf8, and encodeUtf8
    # protlude 0.1.6 issue reported 11 Jul 2016: purescript/purescript#2225
    inreplace "purescript.cabal", "protolude >= 0.1.5,", "protolude == 0.1.5,"

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
