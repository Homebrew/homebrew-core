require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.8.5.tar.gz"
  sha256 "352c0c311710907d112e5d2745e7b152adc4d7b23aff3f069c463eceedddec17"
  head "https://github.com/purescript/purescript.git"

  bottle do
    sha256 "9d9cf746058847a06cfbfdb7fb3a74c9a8c7eaf7dd1edafc604dfb720cdb8c83" => :el_capitan
    sha256 "4e526d5e657750476c3b85f5e2574ac353ecd1afe8b48baba598002b34f9e960" => :yosemite
    sha256 "9b0a0f6273917d86c9039025e92da4f88a74b678eac0810ae3cb27ae10746b77" => :mavericks
  end

  devel do
    url "https://github.com/purescript/purescript/archive/v0.9.0.tar.gz"
    sha256 "3c08582cacb909fbf2d2db7e7681afa14efd105d2e47ad93998377b273b853b8"
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
