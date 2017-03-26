require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.11.0.tar.gz"
  sha256 "3ba5469b1244933dd2fe6fd62ec11c34b606863bf37280d0b53953eb271642a9"
  head "https://github.com/purescript/purescript.git"

  bottle do
    sha256 "1cfbe96996e3e66500df1ae97f5701d8e10eec7fb3c95f4706ac947dbedd1863" => :sierra
    sha256 "dbe6d2bbc294b0177736f537547b22886491814c2eeb7f911ce8b3d883e7fad8" => :el_capitan
    sha256 "10a9d1cb56b8db272d770c5def376c50fc3ddca69be52a9d31da5cacba390f8e" => :yosemite
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
    system bin/"purs", "compile", test_module_path, "-o", test_target_path
    assert File.exist?(test_target_path)
  end
end
