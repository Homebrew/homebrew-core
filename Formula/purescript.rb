class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  # TODO: Try to switch `ghc@9.2` to `ghc` when purescript.cabal allows base>=4.17
  url "https://hackage.haskell.org/package/purescript-0.15.9/purescript-0.15.9.tar.gz"
  sha256 "952bf9478720df1830922d6bad4080d121d6912fc04542110598f359f4d73cc5"
  license "BSD-3-Clause"
  head "https://github.com/purescript/purescript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd72e7c0c64ecb4ac252805ea28684a37ff142adabcf20fb9bc09727e6b004cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71991d423702456cdc46684650f8c78d543def0546ed6f957dc30f8b05971390"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b347de3220dda6d941c03240a6639269cf891b3b6e0d08d047b589b9ef939ede"
    sha256 cellar: :any_skip_relocation, ventura:        "3b5e11beb16f9314982baa74332e016a64e96490f652ce3c53fa7140fae0a6bf"
    sha256 cellar: :any_skip_relocation, monterey:       "4b9db4c4d8301357c061d7622c330aa573e20e23d1b767831e0f6152f3275c69"
    sha256 cellar: :any_skip_relocation, big_sur:        "51bc84c2a6df972b20bc21680f5109d5dd130aba3da3dbc8dee40d5ed090048a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d75771ba9b18fbdd1c29b2a371ed851cd89b4021e139186930b1da6e8be1c24"
  end

  depends_on "ghc@9.2" => :build
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
