class DhallJson < Formula
  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.7.3/dhall-json-1.7.3.tar.gz"
  sha256 "7d8e525dfbbfc7abce0356fff5e3e359e1af68a069c0e383acd667e031b1412b"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ae9162d20ec0389c3c8ff3f047dea0516e1a89218bba14fdfd7707e1d1dde7b6" => :catalina
    sha256 "1b1d890af62e9a217a0f5d0d0e75e3181faa5d39351d541999af3f7620c4da83" => :mojave
    sha256 "56688e4d7219ee14cb6a51471016ff65e5e0b6edcd18ecd8e5d5157e3d8567dc" => :high_sierra
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
