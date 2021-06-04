class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  url "https://hackage.haskell.org/package/purescript-0.14.1/purescript-0.14.1.tar.gz"
  sha256 "db13fbb071c92e004c630a6d1a995b42622b187435f87da9d656f80ab0561933"
  license "BSD-3-Clause"
  head "https://github.com/purescript/purescript.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "f8a83c51a9087459dc56fd67fccf1ad0868eb8213f7124b3209c978ee0a24bca"
    sha256 cellar: :any_skip_relocation, catalina: "e6b40372ac397f05961bc9a31d160aef87232b1327b4453b6e08364b5af729b7"
    sha256 cellar: :any_skip_relocation, mojave:   "914b59ba55a51536e523c300a77b02b55ba7f2fb2fef09d5f96b1edd90cc1b2e"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "purescript-ast" do
    url "https://hackage.haskell.org/package/purescript-ast-0.1.1.0/purescript-ast-0.1.1.0.tar.gz"
    sha256 "a2f5403f9663d57957f2ae1692e52bdff0dd677876f93c1ae9bbf7b0ef9af38b"
  end
  resource "purescript-cst" do
    url "https://hackage.haskell.org/package/purescript-cst-0.1.1.0/purescript-cst-0.1.1.0.tar.gz"
    sha256 "3999f4b5c824099ea9cc9a74dd543b28ba9c5e57cbef2ff2966baa0b58725816"
  end

  def install
    (buildpath/"lib"/"purescript-ast").install resource("purescript-ast")
    (buildpath/"lib"/"purescript-cst").install resource("purescript-cst")
    system "stack", "install", "--system-ghc", "--no-install-ghc", "--skip-ghc-check", "--local-bin-path=#{bin}"
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
