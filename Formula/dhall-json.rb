class DhallJson < Formula
  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.7.5/dhall-json-1.7.5.tar.gz"
  sha256 "3e1aeed7d3cd58ee3c220e724ca1f6128464a204d45fff225b4a70363bbaf3ba"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "a1e0cb4f7e4a7e0994b43ecd783240356631d36655cfbf59a903cc3f6a799242"
    sha256 cellar: :any_skip_relocation, catalina: "050f219d8050cf46a54487e0cad414374a5d2b4a6422d1e2e2c7a682149c3afb"
    sha256 cellar: :any_skip_relocation, mojave:   "56007f50e5a52a3062973574ddc1e888d74698e3ac9310ed223ce5c131834cb9"
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
