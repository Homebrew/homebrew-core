class DhallJson < Formula
  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.7.8/dhall-json-1.7.8.tar.gz"
  sha256 "7034a8367472d92405db9b45052cb0fbc31dc72c524b0597dd268f145b388c3c"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9d96bc693a02bb5b1910d907b4019f591a59ad9178c8eb146355e0303a83e76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "758387cdc99b7c74b74afd53d953d288834a91c0e9e34f3823bad458555c2b8c"
    sha256 cellar: :any_skip_relocation, monterey:       "bf771b4d324e4cfafe6626296f5245e0b9a1b8050d1c3e35618032094dd30c45"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fe927c9bb161d8280a7f7e4ae7f0c02e981fc1d7e78292d48ded976c496be38"
    sha256 cellar: :any_skip_relocation, catalina:       "e4d2763620f32d19b77495ff7703835a791f81787b20557b7b29e494969cebcd"
    sha256 cellar: :any_skip_relocation, mojave:         "782a3471003a7a941e45c635b708cf33a8e12eac2c08c890a6f44d1379e476ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60b0ba1a22370321ab92f86812c2f20862de6f95604e6010dac36a61694893c4"
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
