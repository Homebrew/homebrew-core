require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.11.6.tar.gz"
  sha256 "8bd2e4f844666a553d93c2e55c72c6361fbc08c706157d9d975dc7c1b730304e"
  revision 1
  head "https://github.com/purescript/purescript.git"

  bottle do
    sha256 "bbf10500d5f5854eb88270adb100df01a42e906a8f01cde8a4b0da9231d6a679" => :sierra
    sha256 "e56ea05f1c2756191a652ff41ea48723dac38aa96a929f5225d126f54da593d3" => :el_capitan
    sha256 "c642ca03b506c0d38db02b713d5f50b2157e215dafc6e8beb24659e9b7f027ec" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

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
    test_module_path.write <<-EOS.undent
      module Test where

      main :: Int
      main = 1
    EOS
    system bin/"psc", test_module_path, "-o", test_target_path
    assert File.exist?(test_target_path)
  end
end
