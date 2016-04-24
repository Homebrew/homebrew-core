require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.8.5.tar.gz"
  sha256 "352c0c311710907d112e5d2745e7b152adc4d7b23aff3f069c463eceedddec17"

  bottle do
    sha256 "011402d31c3f794644abcb2589470de0e79806e66d1a5ba5d512450747bb1119" => :el_capitan
    sha256 "8bc3cc825c44f7241be61ba91967d62070f1cc11e8acfed5b589e1377997ee79" => :yosemite
    sha256 "806959fb61e34234a3463a5a2b1143060353ce763a4608bdcaf117d0ff509ed5" => :mavericks
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
