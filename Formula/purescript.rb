require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.8.4.tar.gz"
  sha256 "e7465be3fd9a9d16cb3050c0a97feb80e4a9329844b9eb125ce8a2aec7881682"

  bottle do
    sha256 "01e00cf9af34ca430a21a41726360ea345c7c874175b8de4c2872566eba84c2c" => :el_capitan
    sha256 "260f61c6f2bf9a7cb31db374117919e8bd21635db1a57d92cc24412bd657a9d9" => :yosemite
    sha256 "5416e12c301240f98d29759d280f408397cd70e8629bd16aac742e2be902eade" => :mavericks
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
