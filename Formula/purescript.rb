class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  url "https://hackage.haskell.org/package/purescript-0.14.4/purescript-0.14.4.tar.gz"
  sha256 "730b0ef2d479c1655f4ed7b1515629fd76bfbad57563779bf45e6ce63d48aa61"
  license "BSD-3-Clause"
  head "https://github.com/purescript/purescript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "343622a265f66e7215f07b123360e90bc97193d65469dca3ff6e91277cf60c40"
    sha256 cellar: :any_skip_relocation, big_sur:       "278de2e34af5d97c2c98065ab0c91008a1c63f37c43f90cffc2241c19c5c5100"
    sha256 cellar: :any_skip_relocation, catalina:      "1fd8a122d9ae081b9a059e589d99db3f323d14800d99d4fc52cdc76e3315bb7d"
    sha256 cellar: :any_skip_relocation, mojave:        "f49b7ba780c3a83c9b8d6c4420c56639860980dfd20273cd915326cd13778f9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f74eea13946485d1f45ef80b0232715f22f06cc0af05e3febeafa0e60d897a63"
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
