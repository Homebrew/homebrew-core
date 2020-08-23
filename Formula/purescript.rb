class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  url "https://hackage.haskell.org/package/purescript-0.13.8/purescript-0.13.8.tar.gz"
  sha256 "701fac49de867ec01252b067185e8bbd1b72e4b96997044bac3cca91e3f8096a"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/purescript/purescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3fd65800108e0e185468ca1779a8e6599e1834be1f9f1179da5d964221d82461" => :catalina
    sha256 "2438c8f73284b0c5923f7bace263e0b00b8df592b073127cd4dd16178d512199" => :mojave
    sha256 "a12832fe00786da347d0069578ff78556aa93890a28e5ae36497e3b4b7f68aab" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  depends_on "hpack" => :build if build.head?

  def install
    system "hpack" if build.head?

    system "cabal", "v2-update"
    system "cabal", "v2-install", "-frelease", *std_cabal_v2_args
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
