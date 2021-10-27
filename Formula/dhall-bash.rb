class DhallBash < Formula
  desc "Compile Dhall to Bash"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-bash"
  url "https://hackage.haskell.org/package/dhall-bash-1.0.38/dhall-bash-1.0.38.tar.gz"
  sha256 "01a1164830da11fa270a3bd6fb9fb6e39d50e400a7ec6b42aec4da41c9c7dc5d"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b815cab1ba135f2682f49756077b7712938e9d84b9487b77498f1158d6e0fbb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a024b04b527c5f6863ace794e5f83afe92b1b16203acd23f1e95e3e27901cbcf"
    sha256 cellar: :any_skip_relocation, monterey:       "23fbafed4e2a6ac0fc36cb93b475b0a385ad9d56d01547decc0e2cf7f2bc1883"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5063002c22244dd97c80f34b28b9b185fd46d64b11ece003eace16ea54d9a65"
    sha256 cellar: :any_skip_relocation, catalina:       "49c267f3236157660b58386c17d9f158c1c4df110dc3f112fdc20b565f90334e"
    sha256 cellar: :any_skip_relocation, mojave:         "ced176f284777f2578f2432fd2943a5e872fbaa0486cde7790e831ad1c116dc8"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "true", pipe_output("#{bin}/dhall-to-bash", "Natural/even 100", 0)
    assert_match "unset FOO", pipe_output("#{bin}/dhall-to-bash --declare FOO", "None Natural", 0)
  end
end
