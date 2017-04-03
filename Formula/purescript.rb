require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.11.2.tar.gz"
  sha256 "ce90ed331b8d22e07ff46e72e097b1432c10a696c6508468a24a3580ddaf8bf0"
  head "https://github.com/purescript/purescript.git"

  bottle do
    sha256 "f7fb4253fa3153d938290842f053b275f97733655f8cb22e6878d48ed7e53970" => :sierra
    sha256 "ea3fb78fbd602e86349b38777fb595ab05c96322484c53f6a38e66e52004a25a" => :el_capitan
    sha256 "06cc356852d5f056dc8b7a162b7de7bc3c6c5ce3cff6e2391586d35059b85ccc" => :yosemite
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
