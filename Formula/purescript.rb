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
    sha256 "ffe0e6ec4234b1c57ed36f6a5de31bb06e05b7c01a25a4667880a7295837cc7d" => :mojave
    sha256 "c68dc6a3d29335c469dd96649f490a3f8b8af267e86ba0740ceb5da3556a8122" => :high_sierra
    sha256 "587f83a8e1ba6acd493bb82b75413d155cd7e8afd22d355c539eafe7b7bc2958" => :sierra
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
