class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  url "https://hackage.haskell.org/package/purescript-0.15.4/purescript-0.15.4.tar.gz"
  sha256 "df279079a7c78c5b1fa813846797e696787f5dd567b1b6e042f7ab6a2701868f"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/purescript/purescript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3af057d6c05e7d8f34efd7f54644b7b40572c1328b98049cc56091d227ed711a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a8a98c6074003a2cac05b0000dcd4bd4a56257bead415c8d83219a6971c3449"
    sha256 cellar: :any_skip_relocation, monterey:       "03f1c8886111c868c23016830e500b19da65ec83647260084643ba685f8754b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5f471181f5d4646065768c0c254d3a2cb4dfb620c8cd419d7d1489e7333ddcc"
    sha256 cellar: :any_skip_relocation, catalina:       "b34d1ebbafc7634924db56889538e81a3c8a719cdfef4a5b8732b474cc0563e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65086d3ff503c3ceb31b06b04e7d427a31dafe63b9fbe200050c36f69860ac94"
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
