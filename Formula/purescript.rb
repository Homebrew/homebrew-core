require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.10.5.tar.gz"
  sha256 "cb38d14e353bf200471385dd08dc5108f4f8690a76806e79c8f2fb3f8facca9c"
  head "https://github.com/purescript/purescript.git"

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
