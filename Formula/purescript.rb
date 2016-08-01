require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.9.3.tar.gz"
  sha256 "70ea9ea189300e8ce7ea89eec818a1c9e39be1e758638898b936028fc0155783"
  head "https://github.com/purescript/purescript.git"

  bottle do
    sha256 "60b40af395e3615c149387c3458e56938515cf25550e8f538393481b0971b6a2" => :el_capitan
    sha256 "604caf2894207951855597f14cb3b07b438743132ed07e011dfeed29570add96" => :yosemite
    sha256 "c0bf1c64c6f1bc7653468b757f2831ba5f0339df7bb20ea8edf60d6389a6eb48" => :mavericks
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
