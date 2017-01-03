require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  revision 1
  head "https://github.com/purescript/purescript.git"

  stable do
    url "https://github.com/purescript/purescript/archive/v0.10.4.tar.gz"
    sha256 "4224d5595352ad000e3b0b39c3f9e4d21ddddad337b651a5bc7480eecfe731e3"

    # Fix "Couldn't match type '[Char]' with 'Text'"
    # Upstream PR from 2 Jan 2017 "Update bower-json to 1.0.0.1"
    # https://github.com/purescript/purescript/pull/2531
    patch do
      url "https://github.com/purescript/purescript/commit/b84ef77.patch"
      sha256 "1fd272dff1a09b1bc49e9fea54d829a5fdee04487a436b97b3e573513b96f532"
    end
  end

  bottle do
    sha256 "7c0b7d34fb71532086dcc894d2bd3c373f1323054c324c4595b1ee5cb4c2ec4b" => :sierra
    sha256 "7c1dc5b5210d35de3ba3517ed8fe164fb8cfb31a2c4238807002706274450c5f" => :el_capitan
    sha256 "91abcbe9675b4ddc657444ce6d4580c75cac7830155ced0260e0ccbcef4dcb03" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
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
