class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  url "https://hackage.haskell.org/package/purescript-0.14.5/purescript-0.14.5.tar.gz"
  sha256 "36c86445da58b8017aa98ba2ab975af7812b9ef739f0b8e7360740d5200ac319"
  license "BSD-3-Clause"
  head "https://github.com/purescript/purescript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5f30397c026c4a302ab5b7d35411a14a73a928aec418f160aa51749df0faa008"
    sha256 cellar: :any_skip_relocation, big_sur:       "d84a41a6c2d4f7a24193e30d9b47e25e700805000829367ef6027fd01bd7c113"
    sha256 cellar: :any_skip_relocation, catalina:      "86759c6e909aa900c4c01d2345b033d29f7121f1fb36c58955ef86c9c47cb61d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3e65f7777018972678cb3d3b18f992958fa7c1278f056c240bcf1e6deca940c"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "purescript-cst" do
    url "https://hackage.haskell.org/package/purescript-cst-0.4.0.0/purescript-cst-0.4.0.0.tar.gz"
    sha256 "0f592230f528ce471a3d3ce44d85f4b96f2a08f5d6483edfe569679a322d6e64"
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
