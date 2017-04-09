require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.11.3.tar.gz"
  sha256 "7b351b1d2cffb423e096708abfa99915a5330b587d059c63d9f57eba54a03545"
  head "https://github.com/purescript/purescript.git"

  bottle do
    sha256 "8c197b063c3327791b4524f7be72e6dec6fd043c36012c66c9ae902aedb69d7f" => :sierra
    sha256 "a92b1ddff7b3bbd0452a112c1d7e38b01edd2c7df9bbdfa02960647353dba816" => :el_capitan
    sha256 "0ec3f9d84855d3a9f1bf6ad50686891439a915bcedfe128c21befaab696d8e43" => :yosemite
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
