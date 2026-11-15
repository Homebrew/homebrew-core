class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  # NOTE: If the build fails due to dependency resolution, do not report issue
  # upstream as we modify upstream's constraints in order to use a newer GHC.
  url "https://github.com/purescript/purescript/archive/refs/tags/v0.15.17.tar.gz"
  sha256 "9c397f31c6864491d3f2588acb8e58ecde493c39ec380aaf845458213f1ddab0"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/purescript/purescript.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4e72779d2a8eb53130a068d910252049522cea40808c689c118ee9689c298b82"
    sha256 cellar: :any, arm64_tahoe:       "e4c221120015d3fd023a9203a494a212891a773adb3d6bbaf4555d6d5c5e9f74"
    sha256 cellar: :any, arm64_sequoia:     "197217b63df2f12b97d25c3fedb75b484555296b9aafafd167e41f28af72801e"
    sha256 cellar: :any, arm64_linux:       "1a7bf3e4e1e9b44beb11b4c4d31852dc7a7e2361739dd4ccb6eda494af067214"
    sha256 cellar: :any, x86_64_linux:      "876ea1c2d6d86e4af19942318c59c56ec3cc2cc5c55d04c2802d323b831af0d6"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  # Minimal set of dependencies that need to be unbound to build with newer GHC
  def args = ["--allow-newer=base,template-haskell"]

  def fetch
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--only-download", *args, *std_cabal_v2_args
  end

  def install
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    test_module_path = testpath/"Test.purs"
    test_target_path = testpath/"test-module.js"
    test_module_path.write <<~PURESCRIPT
      module Test where

      main :: Int
      main = 1
    PURESCRIPT
    system bin/"purs", "compile", test_module_path, "-o", test_target_path
    assert_path_exists test_target_path
  end
end
