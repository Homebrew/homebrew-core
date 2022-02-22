class Dhall < Formula
  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.41.0/dhall-1.41.0.tar.gz"
  sha256 "21615d8e00601867bafb0e46679d724fda535f12ff17a1aeaf53db327338ecc5"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "853dad0af9fead6ab329afff32c6bc8c78909d14a1680e9310b121aff8bd3c7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f04d38a8b19a94fa4899a34207290570bfcb84887794a80f05f405372684c920"
    sha256 cellar: :any_skip_relocation, monterey:       "f52c667b08fc7a59fc62cf8e01dd1b053e31ef288b49a48ac9c73a2d15875d64"
    sha256 cellar: :any_skip_relocation, big_sur:        "5294800dc990a7ea440c64b563f6e0ca31fbc882f4f4473859957f1cc07414b7"
    sha256 cellar: :any_skip_relocation, catalina:       "3bb12bdb7387fd090b9ee56bf4b40eba1079ca2f0a9b242338e06aa08b24a45f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ad030f24cfc4139cc0dcbe391609b60a18f7d96a86c9e6e96f0b6be4d5817cd"
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
