class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  # TODO: Try to switch `ghc@9.2` to `ghc` when purescript.cabal allows base>=4.17
  url "https://hackage.haskell.org/package/purescript-0.15.8/purescript-0.15.8.tar.gz"
  sha256 "a01c082333087acdd0a16e2c4141bed7d080d5c7c2388ac29934c3c4242cadc0"
  license "BSD-3-Clause"
  head "https://github.com/purescript/purescript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af316cc41048b5e9226d527c563b4760d1737301363dcc3436140627b1c5ded9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4aed0aff428e3f616024b346ca336f72a48f1f0e8615ed6ab534f6f1936dcf8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ceec21c85985aac46ab4a67eba28d635f202fc9c9991ef92c935be27c4da356d"
    sha256 cellar: :any_skip_relocation, ventura:        "ded3866996ba71efa15fca57681e2613c7366f695472d1ba1ffb66bb6fafe562"
    sha256 cellar: :any_skip_relocation, monterey:       "5aed04eb3cef69d0f7a39460511f63d4e8b654fbfa00d321bfea3616611ac925"
    sha256 cellar: :any_skip_relocation, big_sur:        "451d87044048aab4dce34b4d8df3ba1d5be8447bdf1c6a12c3e2ff3796e5af06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b3d325dfee9971fff223e7e9682ad7817661cf9d2bcc7538a2d71bad8a0d3ce"
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
