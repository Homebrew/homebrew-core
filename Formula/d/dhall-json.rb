class DhallJson < Formula
  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.7.12/dhall-json-1.7.12.tar.gz"
  sha256 "ca48cd434380cbd979dbb12889f90da8fdc1ea90bc266cab14f061c60e19d5fa"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "aa28d7105b92415f10bdf28679bc631644527208492877b239ec7dca49a4576b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c953aa5b6578f99c770fcfea9d3ab337fbbb36dd35130f423b067b81aa32433c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9828ba27a2b38b47259226edeaa90ada547b3bcbb4a19a06c6268ebfb4e79f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "128907da1d0ae87a97d3e2eafaeb0976fb31ef6806826b8d1ab782781436834d"
    sha256 cellar: :any_skip_relocation, sonoma:         "6fe9a18931ce049c972b01ece18dd99b5519c8b81dc297ea739c855222501849"
    sha256 cellar: :any_skip_relocation, ventura:        "3a07abe91ba35acd16e9e3a4d293895b3722dde3c3b55ce9212d70220512c9d0"
    sha256 cellar: :any_skip_relocation, monterey:       "4cd90ca4159871376eb10cfc730116e7a55d78260aa9705dcc87bb00530ee9bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06ab63373f3d40884b9111382390b21525460927f12692a158e3983f68c9e0aa"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    cd "dhall-json" if build.head?
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
