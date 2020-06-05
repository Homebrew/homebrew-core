class DhallJson < Formula
  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.6.4/dhall-json-1.6.4.tar.gz"
  sha256 "3f0162949d53e10c23ee11ddfe92a808dc5b18c5a40289015c65baec0450266f"
  head "https://github.com/dhall-lang/dhall-haskell.git"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "72db44b7eea65e15d46136da6b6b7d82cccb3072273f47b915c96ce287ccf36a" => :catalina
    sha256 "7152d5da04a8064eeeab62bb6a7c908d0968c700e3202160b49851de2f45643e" => :mojave
    sha256 "7d60dd99e46d3693fbdbc1107fa571c45357b7f853279c1340c2b147748b1ff3" => :high_sierra
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
