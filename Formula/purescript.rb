require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://hackage.haskell.org/package/purescript-0.12.5/purescript-0.12.5.tar.gz"
  sha256 "692815eb8b35db7b4880b1627d43426e1d8a2ab10ad3877f6aff5110ca06f636"
  head "https://github.com/purescript/purescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fcec4062d8cc3fd4d557968885af1fdbdc0c0c4155360ced8410750d7c6628a5" => :mojave
    sha256 "4783296a797a920116da18dade95b0e88621a088c9afffe8f2398a12d9fb1a79" => :high_sierra
    sha256 "0bf8e8eb526136769d2f8e969111cfe7842a3e2a7ce96e33195dd24e3b4141a6" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    cabal_sandbox do
      if build.head?
        cabal_install "hpack"
        system "./.cabal-sandbox/bin/hpack"
      end

      install_cabal_package "-f", "release", :using => ["alex", "happy"]
    end
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
