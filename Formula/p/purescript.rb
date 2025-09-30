class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  license "BSD-3-Clause"

  stable do
    # NOTE: If the build fails due to dependency resolution, do not report issue
    # upstream as we modify upstream's constraints in order to use a newer GHC.
    # TODO: Switch to `ghc@9.8` on 0.15.16 and drop `--allow-newer`
    url "https://hackage.haskell.org/package/purescript-0.15.15/purescript-0.15.15.tar.gz"
    sha256 "9c4a23ea47ff09adc34e260610beabd940ec5c15088234cf120e8660dd220e67"

    depends_on "ghc@9.6" => :build
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "2b9aeb3f72c90bcf7747ac0000e2609b7d39ad535d00a7ba733dd40f51dbcb5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3c1767c6fe89d2e486911f5c60c81222996c3b47971d57b533bb57ace2d22a4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69551d14eb101c3640582d055929b2d6338310c5422530edb2b1e35dbd648830"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "720d717ad6d38ba67c288cca2cc03b236cf29ed3badeb823743d1ab091f8704f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d4a9daf4fca5b870a4e45590a13e56e8e78f9bef3729047f064a48a86e7e3f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "133fd37b35ea0ebc610965f55332f02bbf67a00db14c4b518f9e7b714fdd705f"
    sha256 cellar: :any_skip_relocation, ventura:        "25f3df8f4c4e5eaf94f4fb9411dfcd48ffaaf257f96e454eef88ff387dd7bc8d"
    sha256 cellar: :any_skip_relocation, monterey:       "a5cf0585bded8ce93f09124d885a8dc00b373b6ca63407300d5b3bcc10aebe9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b63d16bc91ca4f7bb745607399bf01273f7a4b31afb689ea10b7db7ac43bd13e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c07fee914dfa9648df6df6152b7c5d7f0297d2e8133a653a4f3511dcfb72b01c"
  end

  head do
    url "https://github.com/purescript/purescript.git", branch: "master"

    depends_on "ghc@9.8" => :build
  end

  depends_on "cabal-install" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    # Minimal set of dependencies that need to be unbound to build with newer GHC
    args = ["--allow-newer=aeson,base,memory,template-haskell"] if build.stable?

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
