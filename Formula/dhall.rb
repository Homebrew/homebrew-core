class Dhall < Formula
  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.41.0/dhall-1.41.0.tar.gz"
  sha256 "21615d8e00601867bafb0e46679d724fda535f12ff17a1aeaf53db327338ecc5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0cc2bae4735fcb42228ee3bc7af4148d9153e6d58580a403003da415988c58c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8fa029427964fb30ec93ed20f47ebd690f9482153e429df2cac834a957064980"
    sha256 cellar: :any_skip_relocation, monterey:       "d5ca50eb37b6e4552ae8bf34637b09052bb7896649fed4e121e624456867ca4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8548f501282fd5d402a2253a8508c6ce100a4f60bf7989cc07b052ce40ea84ef"
    sha256 cellar: :any_skip_relocation, catalina:       "13df84eed84e1d128dbd4e462f5306c49b897748f3cdf1461b00b1e2e69a2d89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ebb0b8be8598a3d133d4d3ee2d43cdaab53f9e181415995146db01c29292a71"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    man1.install "man/dhall.1"
  end

  test do
    assert_match "{=}", pipe_output("#{bin}/dhall format", "{ = }", 0)
    assert_match "8", pipe_output("#{bin}/dhall normalize", "(\\(x : Natural) -> x + 3) 5", 0)
    assert_match "(x : Natural) -> Natural", pipe_output("#{bin}/dhall type", "\\(x: Natural) -> x + 3", 0)
  end
end
