class DhallJson < Formula
  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.7.7/dhall-json-1.7.7.tar.gz"
  sha256 "94d2ef7ec16a36a5f707e839e883a19c5cc9b921083c2c5f6245119019006698"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "d1dd64ef3b551cb9bd3ec4de1ddc336457ca588421b2b5dab1f6ecbc609fd4b0"
    sha256 cellar: :any_skip_relocation, catalina: "b75a7ef02eefee86b173f6e8c7b6eff5e3247a319b86a2d3f37abc86e7230cee"
    sha256 cellar: :any_skip_relocation, mojave:   "004e35525351878b319875287e858d58b4f0acad0839fc3a00122364c8048c2d"
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
