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
    sha256 "b1963ea8c20e0deaa6eabbeee2de8295c80b253265b858db30747b4e152c89ee" => :sierra
    sha256 "248c2c94c06bdb6e9057d461c30d024e71bbd9b17cbf0bb8031ce47d30d484f1" => :el_capitan
    sha256 "9bfd9ec165d70ba11ce9f91911a04952670fe1192b36e5d582190a12629988bf" => :yosemite
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
