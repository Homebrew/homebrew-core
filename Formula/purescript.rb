require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.11.3.tar.gz"
  sha256 "7b351b1d2cffb423e096708abfa99915a5330b587d059c63d9f57eba54a03545"
  head "https://github.com/purescript/purescript.git"

  bottle do
    sha256 "1fbb175d8451ad2ff8720095cad4aaef8720388db7c9f1e29da3454949ec4dba" => :sierra
    sha256 "d65db6df1aa7385951b6ae3435d92583d551e4bfc8486004ab30d7235d2bfc39" => :el_capitan
    sha256 "8ac4604de26f41fb79c880c4440a39377b0b5257434fc344a688d65f17954c26" => :yosemite
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
