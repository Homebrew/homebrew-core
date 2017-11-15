require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.11.7.tar.gz"
  sha256 "56b715acc4b92a5e389f7ec5244c9306769a515e1da2696d9c2c89e318adc9f9"
  head "https://github.com/purescript/purescript.git"

  bottle do
    rebuild 1
    sha256 "6e3c8f33ac8e6b8af9e4d7b7da7d6116129048e1e553337e7d887aa5996cbb59" => :high_sierra
    sha256 "c6719ba1cd153eeb9816ffc5ee3a10e5d7e25d618689ce2f416d43aeaf1a525e" => :sierra
    sha256 "474ce08419ecaaa6456f828674adf095c4b07af557f7a15881071a52ec907e98" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    inreplace (buildpath/"scripts").children, /^purs /, "#{bin}/purs "
    bin.install (buildpath/"scripts").children

    cabal_sandbox do
      if build.head?
        cabal_install "hpack"
        system "./.cabal-sandbox/bin/hpack"
      else
        system "cabal", "get", "purescript-#{version}"
        mv "purescript-#{version}/purescript.cabal", "."
      end

      install_cabal_package "-f release", :using => ["alex", "happy"]
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
    system bin/"psc", test_module_path, "-o", test_target_path
    assert_predicate test_target_path, :exist?
  end
end
