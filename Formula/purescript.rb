require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  url "https://hackage.haskell.org/package/purescript-0.13.6/purescript-0.13.6.tar.gz"
  sha256 "12f5efa2e157a8d57e6f5a4318d08ff57796802ec3e404f5436371b32f1f5af7"
  head "https://github.com/purescript/purescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5f29a4323a22ee658121f0923720e7a4e410136ea3b868d79198ce8ae5d4ffa" => :catalina
    sha256 "7df056f7cff1e30232690dabc6fcfd9efb04d51f23e1e044df7bcd38b72740d1" => :mojave
    sha256 "2994c4912472097dcdd4ed5f42046656c9a6e1174e1b7ebbf1a9ba50aed2f3f7" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  depends_on "hpack" => :build if build.head?

  def install
    system "hpack" if build.head?

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
