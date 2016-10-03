require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.10.1.tar.gz"
  sha256 "bd2ef929d9182920df395bbe5935d124ea62a4f4163d328549629da9bfdbb273"
  head "https://github.com/purescript/purescript.git"

  bottle do
    sha256 "28f48f10dba3d9065a7bcd4d245b7aef7a502796d630d05a339b3e1bfd82c3b0" => :sierra
    sha256 "a3d910d2e6496c498f464df931ca6385fb245c9b9a9f6b6a5a7b2272176e8910" => :el_capitan
    sha256 "ceef5225bc63048357300290ca28dfdaff4f35861ffb35045b14cb9b28d37d88" => :yosemite
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
