class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  url "https://hackage.haskell.org/package/purescript-0.15.2/purescript-0.15.2.tar.gz"
  sha256 "a4d99367b98dcc25f22721b633ca2a9d339131776f8e827b35a9738b7a3cd587"
  license "BSD-3-Clause"
  head "https://github.com/purescript/purescript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5055caa85ea3a46015846050200dbf04907ab27351337ff5c615410c9bee2da1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "452105a11118032f9427dadcd2edd94be51a8d758a4f86da26559b2a551cbcc1"
    sha256 cellar: :any_skip_relocation, monterey:       "00ea8f3aff0cef01080805632c9725cb5b1b32c5b81eb4f15146052596d36210"
    sha256 cellar: :any_skip_relocation, big_sur:        "d18e19fdc8165edbb3bb69e0c0b50099364c37653f2de7804615483e8a5c84d7"
    sha256 cellar: :any_skip_relocation, catalina:       "3dd1a8b30aa1f48abe6cddd4be692984fb7566f7efdea872f5572b7914e1d5fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "498682974e6ae80326a87d34d62c42012558bcd2ebd13b9a788c00f51f055814"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
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
