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
    rebuild 1
    sha256 "6e3c8f33ac8e6b8af9e4d7b7da7d6116129048e1e553337e7d887aa5996cbb59" => :high_sierra
    sha256 "c6719ba1cd153eeb9816ffc5ee3a10e5d7e25d618689ce2f416d43aeaf1a525e" => :sierra
    sha256 "474ce08419ecaaa6456f828674adf095c4b07af557f7a15881071a52ec907e98" => :el_capitan
  end

  depends_on "ghc@8.0" => :build
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

      # Upstream issue "Build failure with protolude 0.2"
      # Reported 11 Sep 2017 https://github.com/purescript/purescript/issues/3065
      install_cabal_package "--constraint", "protolude < 0.2",
                            "-f release", :using => ["alex", "happy"]
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
