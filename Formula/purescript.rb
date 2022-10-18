class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  url "https://hackage.haskell.org/package/purescript-0.15.6/purescript-0.15.6.tar.gz"
  sha256 "75bc618d1db6ce7f96db9fed26029e450718a1db66f8921ee1856d73ec97e8a6"
  license "BSD-3-Clause"
  head "https://github.com/purescript/purescript.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d2d01f66f7cb985296b1b4801db52a3c47686bba33b4cf36ba8cb405bd45c76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64c3b8e647e8fb4b350752742f0368ad53ca0e384a6f0658118d9eb8d3f28a1d"
    sha256 cellar: :any_skip_relocation, monterey:       "d7ad06ab5c115f7edd2db2644aeeec186cf969ebc7933430a27a0d47cb340236"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebda8f4eb5ce1151fb27645529426d4c380a3cd3bd6c0782e429985d1167dd58"
    sha256 cellar: :any_skip_relocation, catalina:       "e9ebb7b6dab162ee3ce9e057f39328a53f15fa7b7558af6e6ea1d8cda9b6cf65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67a8df7632e6bd654de3a2963fe3739d6441a7054538a4c1bf6eb7207d535bea"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    # Use ncurses in REPL, providing an improved experience when editing long
    # lines in the REPL.
    # See https://github.com/purescript/purescript/issues/3696#issuecomment-657282303.
    inreplace "stack.yaml", "terminfo: false", "terminfo: true"

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
