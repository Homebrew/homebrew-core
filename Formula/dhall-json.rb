class DhallJson < Formula
  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.7.10/dhall-json-1.7.10.tar.gz"
  sha256 "e15cd486b287ed281cd56da8d0603bb70dbfa33f2b3e107682d82935dad3f785"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ea1423f43fb9a7fa3789514ae55808ee1a7d9fa90efa1ad831330b61e43ccce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56e8a007ff90bf159482f8bdefd4f9d322b81aac086e7de1fed6e965b4ddb7d6"
    sha256 cellar: :any_skip_relocation, monterey:       "3e8a970246c08fdf53b34a86c37f89c0356479ce9db6e75196c54bec381642a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e42035c35b1982cac88c2439be1a7277826eaad3d94119397ff95f27924a9ac3"
    sha256 cellar: :any_skip_relocation, catalina:       "cb073ad995a78669e14308df6e1cfb2948d888f32d639ad28a4e28d6f3665fa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "574870ec071224a29cbee1e99f58824e2a8c55f3f754c8d59e571e44e13205b7"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
