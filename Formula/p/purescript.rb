class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  # NOTE: If the build fails due to dependency resolution, do not report issue
  # upstream as we modify upstream's constraints in order to use a newer GHC.
  url "https://github.com/purescript/purescript/archive/refs/tags/v0.15.16.tar.gz"
  sha256 "36abaef46aa3cd0316d924c872987aa186d95654d05aa66060948ab47b161f18"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/purescript/purescript.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e856a32edcdaa55ef9afabd4b6501b84c23e5ec0c2a1956aa0a4f8a3814543b1"
    sha256 cellar: :any, arm64_sequoia: "a27ecd0a2d2433f7687402e1ec2f2769df37a55a7dacde5d835fd72c61e3194f"
    sha256 cellar: :any, arm64_sonoma:  "0c443b1a58e29d35021e9e93da312a28d50f9b94f1bd67d9f1532459d2ca9a34"
    sha256 cellar: :any, sonoma:        "4b53f55f99f4a4df9f1e1c625c00691ee467aadb07a79a575191151ea6bf1dc0"
    sha256 cellar: :any, arm64_linux:   "5bd9b83b53df4fd41498d98d3e0ad7c081af2b46216b27e849069599fbb27f4a"
    sha256 cellar: :any, x86_64_linux:  "93caeafe00b03d257834289be6e260de5d7b15e05f59d53381d55f2f0aae53f5"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Minimal set of dependencies that need to be unbound to build with newer GHC
    args = ["--allow-newer=base,template-haskell"]

    system "cabal", "v2-update"
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
