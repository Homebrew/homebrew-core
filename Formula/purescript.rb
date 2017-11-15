require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.11.7.tar.gz"
  sha256 "56b715acc4b92a5e389f7ec5244c9306769a515e1da2696d9c2c89e318adc9f9"
  head "https://github.com/purescript/purescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1e281b76d895e1791902765491a35ed2524cff90ecb99a72a190b1e0f387b77" => :high_sierra
    sha256 "01c8ec5708e23689a7e47a2cea0a3130cdcc4cce3b621c3b4c6b3653a1481617" => :sierra
    sha256 "ee0a11eb6bfd302a27653c074a0d237b5bdf570579394b94fe21ee0638a8e0ef" => :el_capitan
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
