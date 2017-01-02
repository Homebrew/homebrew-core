require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://hackage.haskell.org/package/purescript-0.10.4/purescript-0.10.4.tar.gz"
  sha256 "2a79006d3861b8cdceaff3c5f7de48be19ba5ed6c2b5fa49f419f2c7e4bc6a51"
  head "https://github.com/purescript/purescript.git"

  bottle do
    sha256 "69ce4961c241c87adcd7f70445f8a8c2dd62d4d4bb96bc7ef85fb50b9c67b167" => :sierra
    sha256 "d1deef9286bf2587b4c279dfb59f751b0ab55bbf31febe12909763ac26ec2429" => :el_capitan
    sha256 "de3f5dbd405d1f1699b12b974d0f648594f93ae7793fade432469f03bf42b9ed" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  # Fix "Couldn't match type '[Char]' with 'Text'"
  # Upstream issue from 2 Jan 2017 https://github.com/purescript/purescript/issues/2528
  resource "purescript-cabal-hackage" do
    url "https://hackage.haskell.org/package/purescript-0.10.4/revision/1.cabal"
    sha256 "a5dacd7a8e23b2aaa2e0f606372496d44cdb9217dbb565b06ce584a22f986a16"
  end

  def install
    buildpath.install resource("purescript-cabal-hackage")
    # overwrites pre-existing purescript.cabal
    mv "1.cabal", "purescript.cabal"

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
