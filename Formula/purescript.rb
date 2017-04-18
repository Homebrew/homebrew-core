require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.11.4.tar.gz"
  sha256 "74a58e01a9b6a18eb000fe40ab521b4c53484d510ea1ecd868899ecf0be1f915"
  head "https://github.com/purescript/purescript.git"

  bottle do
    sha256 "e7072aa63bdcde7a6a96ff26db392f025383e6d0bfce8535f4d2787ebcc9d798" => :sierra
    sha256 "473f0b5ddd0d8d28c9ac28805c4f1a42dd7dd3bdf6e97a5b5f991598be4b4a56" => :el_capitan
    sha256 "1145b4cfb35bb48ada8e9261f93302b50e3c515df4b36a04b889fe940b2e4bf1" => :yosemite
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
