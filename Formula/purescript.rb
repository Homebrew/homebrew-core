class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  url "https://hackage.haskell.org/package/purescript-0.14.1/purescript-0.14.1.tar.gz"
  sha256 "db13fbb071c92e004c630a6d1a995b42622b187435f87da9d656f80ab0561933"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, catalina: "acc7ee0fc127b4d7e7fdcd4bccb83461b4c09e03236c43217d120dcc83275920"
    sha256 cellar: :any_skip_relocation, mojave:   "a8e180565f3214a371f552b4e83420182710040fa7c8fcf85a62f007799dc45a"
  end

  head do
    url "https://github.com/purescript/purescript.git"

    depends_on "hpack" => :build
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
