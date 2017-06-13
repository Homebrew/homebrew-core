require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.11.5.tar.gz"
  sha256 "c184470a4204303b3de92a305005591133c2f7019a12625d2a7d6cd1dd54d5d3"
  head "https://github.com/purescript/purescript.git"

  bottle do
    sha256 "d96b22963b2d563ae807fe7136dca19108ab7ecb78a5b0a4daf503a8797a641a" => :sierra
    sha256 "132ad939e7c3766520dae06a8e7da2cbf905bd1e6f625db405285136c65c394c" => :el_capitan
    sha256 "7ad2e08eee3e2528e376e94573b521fc8d58098018f1000690d69e0b628825ae" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    inreplace (buildpath/"scripts").children, /^purs /, "#{bin}/purs "
    bin.install (buildpath/"scripts").children
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
