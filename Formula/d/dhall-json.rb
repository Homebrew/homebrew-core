class DhallJson < Formula
  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.7.12/dhall-json-1.7.12.tar.gz"
  sha256 "ca48cd434380cbd979dbb12889f90da8fdc1ea90bc266cab14f061c60e19d5fa"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any, arm64_tahoe:   "797620da8d3432df1523f9c08f2fddb86f9131789e9f9b136647773797ac0061"
    sha256 cellar: :any, arm64_sequoia: "b6a6d0a71613903f299ab837b1a9f832f0feeac31c022730153efcab91c9fbff"
    sha256 cellar: :any, arm64_sonoma:  "7284a154c865793b6034a47b3cce5698aec8bfecd12c6d1783fbdd9c815138c7"
    sha256 cellar: :any, sonoma:        "12b5239d5c55e1813c084cb46cec0179a02667e69efa431597f394c85aaf033d"
    sha256 cellar: :any, arm64_linux:   "12060b10c92e108b8d2aea6386aad76d6d895587fe9e12c2c575c6bb80706439"
    sha256 cellar: :any, x86_64_linux:  "001857a118079356b3dd1c8aa8645178b061075f67d67e38645602a1837e0219"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    if build.stable?
      # Backport support for GHC 9.10
      inreplace "#{name}.cabal" do |s|
        # https://github.com/dhall-lang/dhall-haskell/commit/28d346f00d12fa134b4c315974f76cc5557f1330
        s.gsub! "aeson                     >= 1.4.6.0   && < 2.2 ,",
                "aeson                     >= 1.4.6.0   && < 2.3 ,"
        # https://github.com/dhall-lang/dhall-haskell/commit/277d8b1b3637ba2ce125783cc1936dc9591e67a7
        s.gsub! "text                      >= 0.11.1.0  && < 2.1 ,",
                "text                      >= 0.11.1.0  && < 2.2 ,"
      end
    end

    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    cd "dhall-json" if build.head?
    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
