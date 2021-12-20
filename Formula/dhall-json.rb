class DhallJson < Formula
  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.7.9/dhall-json-1.7.9.tar.gz"
  sha256 "f6b9f4f6046648d2c51c6a7d11b5c08b0935d820cc5dfb67aaec5363b7213487"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20fd32c39d1b0fba9c6b65b91419284283ccca19a3e10e492dfe62ae4f31ad9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "458bc2034b51b4729cba015aeb92cfc7c9e14fb563d944a6b536a4d0d17552d9"
    sha256 cellar: :any_skip_relocation, monterey:       "2def3dfcf25865481fdee2aa51ecb987d61889c7d0328b73ade5b16525781e03"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2802e6b1e7cc82c07acb0b7a5bb29508e4905cae741b2f8c0715b577dce1ee7"
    sha256 cellar: :any_skip_relocation, catalina:       "6e5eb791ef5cb206006257679b4212aa56faeb758c539756c6b4eace2cd8743f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "782f51f037bddc53e194282459854f1192fac51693a7d593200970be00457742"
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
