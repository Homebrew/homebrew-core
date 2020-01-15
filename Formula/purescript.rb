require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://hackage.haskell.org/package/purescript-0.13.5/purescript-0.13.5.tar.gz"
  sha256 "44260d0cf86d35eb95e2fc348c986508f9b082f708ab53a3985170e518fd985e"
  head "https://github.com/purescript/purescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "36b113b7dc29c020c148863f3b8e3bbc9ac8b63b4809e2ccdb5910da8711612c" => :catalina
    sha256 "de1dcd768432cd253dc048490823950491cb1de88156104f2091bd32e56a4867" => :mojave
    sha256 "bff633714541dfb63d270a3e3189f56e7e10cdfa46d43d5b89dc9eed7955204a" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  if build.head?
    depends_on "hpack" => :build
  end

  def install
    if build.head?
      system "hpack"
    end

    install_cabal_package "-f", "release", :using => ["alex", "happy-1.19.9"]
  end

  test do
    test_module_path = testpath/"Test.purs"
    test_target_path = testpath/"test-module.js"
    test_module_path.write <<~EOS
      module Test where

      main :: Int
      main = 1
    EOS
    system bin/"purs", "compile", test_module_path, "-o", test_target_path
    assert_predicate test_target_path, :exist?
  end
end
