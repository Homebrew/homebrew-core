class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  url "https://hackage.haskell.org/package/purescript-0.14.2/purescript-0.14.2.tar.gz"
  sha256 "b538dc52b30712d6efd211da3bffa72f77a1e23b49973b017c69ec100623f389"
  license "BSD-3-Clause"
  head "https://github.com/purescript/purescript.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "f8a83c51a9087459dc56fd67fccf1ad0868eb8213f7124b3209c978ee0a24bca"
    sha256 cellar: :any_skip_relocation, catalina: "e6b40372ac397f05961bc9a31d160aef87232b1327b4453b6e08364b5af729b7"
    sha256 cellar: :any_skip_relocation, mojave:   "914b59ba55a51536e523c300a77b02b55ba7f2fb2fef09d5f96b1edd90cc1b2e"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build
  depends_on "llvm" => :build if Hardware::CPU.arm?

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "purescript-cst" do
    url "https://hackage.haskell.org/package/purescript-cst-0.2.0.0/purescript-cst-0.2.0.0.tar.gz"
    sha256 "7a1cacee4d951b5bbbfd57b8aad2baff7a94dbcb5172aef0bce2c18355a2fa6a"
  end

  def install
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
