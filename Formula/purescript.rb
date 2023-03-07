class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  # TODO: Try to switch `ghc@9.2` to `ghc` when purescript.cabal allows base>=4.17
  url "https://hackage.haskell.org/package/purescript-0.15.8/purescript-0.15.8.tar.gz"
  sha256 "a01c082333087acdd0a16e2c4141bed7d080d5c7c2388ac29934c3c4242cadc0"
  license "BSD-3-Clause"
  head "https://github.com/purescript/purescript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c7879d45f85d8c5bad87eaa4fc6b863c532d922c3d659535378aeedf98c57f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ac93f3d18b1a926af83d4147660d4c063e3a7c849d7f06640b56a0222b2bae7"
    sha256 cellar: :any_skip_relocation, ventura:        "a39c1e703d789d9a53de221abcbec712fec5cead9635bbacd3cd1eff5610baab"
    sha256 cellar: :any_skip_relocation, monterey:       "cd49695ea28dcf2a9293a90cf9a48b0445bfdf7bf0f011f89f1ac542a0ddf287"
    sha256 cellar: :any_skip_relocation, big_sur:        "57743bb4580e43a26fb9a3a109fe632e3d93a79953e927baf83faa47d4a8e94c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d13222cbdbca1e5bb032f4ba1b2433a7cf8a2628ffbfa210f8160df6796bbc5"
  end

  depends_on "ghc@9.2" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    # Use ncurses in REPL, providing an improved experience when editing long
    # lines in the REPL.
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
