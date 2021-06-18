class Dhall < Formula
  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.39.0/dhall-1.39.0.tar.gz"
  sha256 "4b117a1db8fa86ecd12b11bc55f3b50627e4b4bb96d0d63ebb7ab2e5086ac2af"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aa391ecec1a629c2a1634c8d873bb8fb469708a04f08662a74f7104503837868"
    sha256 cellar: :any_skip_relocation, big_sur:       "3033cf19e4ae915221dbe28210be943c3f4dc29e0b06d6835ad1385ddb74e0be"
    sha256 cellar: :any_skip_relocation, catalina:      "1d5b510e3ae69e57f7b4579d568a11c5074fc6ff12ebb7f7bd406180a0f13bc6"
    sha256 cellar: :any_skip_relocation, mojave:        "0b7b23cff6a700ecbf39d33fa2d1f1217f94c05123c18106e6acb22ba4024025"
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
    assert_match "{=}", pipe_output("#{bin}/dhall format", "{ = }", 0)
    assert_match "8", pipe_output("#{bin}/dhall normalize", "(\\(x : Natural) -> x + 3) 5", 0)
    assert_match "(x : Natural) -> Natural", pipe_output("#{bin}/dhall type", "\\(x: Natural) -> x + 3", 0)
  end
end
