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
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "dc46630c86957ab0f8713bb673ebd8b3176cb8374e23d82b9a4613d64e269c88"
    sha256 cellar: :any, arm64_sequoia: "9f8d22b204a736137f79983004a77f3995f274f24f5c716b5801c627b0600d56"
    sha256 cellar: :any, arm64_sonoma:  "f0ce77a28523acecc9e492cf6d1f9c05fd54e3c07fe3dfa82d1b2f418a35feaf"
    sha256 cellar: :any, sonoma:        "8f6a356e26d75d58cb5612b0e7a881e964c1e7e95d37085001432a8a823aead0"
    sha256 cellar: :any, arm64_linux:   "dad0e46be82b7fcd262ed011ef76c2f9535e81847d958bc1a73d3057fe0b8f64"
    sha256 cellar: :any, x86_64_linux:  "88d8bb115d51ef1bb8fda45c3dd9fdc87abf0f82a5722f94b776ba103d30f681"
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
