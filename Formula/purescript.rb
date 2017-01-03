require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://hackage.haskell.org/package/purescript-0.10.4/purescript-0.10.4.tar.gz"
  sha256 "2a79006d3861b8cdceaff3c5f7de48be19ba5ed6c2b5fa49f419f2c7e4bc6a51"
  head "https://github.com/purescript/purescript.git"

  bottle do
    sha256 "7c0b7d34fb71532086dcc894d2bd3c373f1323054c324c4595b1ee5cb4c2ec4b" => :sierra
    sha256 "7c1dc5b5210d35de3ba3517ed8fe164fb8cfb31a2c4238807002706274450c5f" => :el_capitan
    sha256 "91abcbe9675b4ddc657444ce6d4580c75cac7830155ced0260e0ccbcef4dcb03" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  # Fix "Couldn't match type '[Char]' with 'Text'"
  # Upstream issue from 2 Jan 2017 https://github.com/purescript/purescript/issues/2528
  resource "purescript-cabal-hackage" do
    url "https://hackage.haskell.org/package/purescript-0.10.4/revision/1.cabal"
    sha256 "a5dacd7a8e23b2aaa2e0f606372496d44cdb9217dbb565b06ce584a22f986a16"
  end

  def install
    buildpath.install resource("purescript-cabal-hackage")
    # overwrites pre-existing purescript.cabal
    mv "1.cabal", "purescript.cabal"

    install_cabal_package "--allow-newer=turtle:directory",
                          "--constraint", "directory < 1.4",
                          :using => ["alex", "happy"]
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
