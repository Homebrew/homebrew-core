class Dhall < Formula
  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.40.2/dhall-1.40.2.tar.gz"
  sha256 "7e158dd30653c230692ddd5cee700cef6a42c27e61e8c47e007fdfe84e229093"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e754bce79f90f537e8b527191567880e01ff681f605f489a4e574a30279f10fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c095e357c8c2c1ef08b5a5e1dcb646871ed65c56c6df3a20d241a85dfc41b86c"
    sha256 cellar: :any_skip_relocation, monterey:       "c92d0a0f3601c1897fe239e66f710019e08430c117337c6ef6a8c03cbf5852d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "57207b67791a42cff31364342026def912392ac0c2994a0efd0d31d0301046b8"
    sha256 cellar: :any_skip_relocation, catalina:       "e002abb60beb3db5596f4e81b88bc5d51c401321e5220a5586de6351edf84b04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92f16e603fff0173ae7a74c1afe2deae0bf31914efebdb0f04e834605e2fa4a6"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    man1.install "man/dhall.1"
  end

  test do
    assert_match "{=}", pipe_output("#{bin}/dhall format", "{ = }", 0)
    assert_match "8", pipe_output("#{bin}/dhall normalize", "(\\(x : Natural) -> x + 3) 5", 0)
    assert_match "(x : Natural) -> Natural", pipe_output("#{bin}/dhall type", "\\(x: Natural) -> x + 3", 0)
  end
end
