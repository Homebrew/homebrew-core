require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  head "https://github.com/purescript/purescript.git"

  stable do
    url "https://github.com/purescript/purescript/archive/v0.10.2.tar.gz"
    sha256 "4b5663e2a5ebb7a2e432f951d0a5d0ddfa08f18304827ec33f609d9b3c1c3fe7"

    # Remove for > 0.10.2
    # Upstream commit "Fix GHC 8.0.2 build"
    patch do
      url "https://github.com/purescript/purescript/commit/46f573a.patch"
      sha256 "6a070c6890480613cf3876da34118aad9bb48c8cf5ca1f285adf69d4f9d99a1b"
    end
  end

  bottle do
    rebuild 1
    sha256 "9061f02205436efeedb0350cec40f81aeb1c714bf3be6ec1ffa2d23a9036cf7b" => :sierra
    sha256 "3d20149072a5c931af2f8d7f7c909c354bcf6babceb786c5660775bdfe28341c" => :el_capitan
    sha256 "549f565313ff57b8bf4b1b7ef7dd07771d3501b24945b25f1ff8bcad20a15b00" => :yosemite
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
