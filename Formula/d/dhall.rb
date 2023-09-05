class Dhall < Formula
  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  # TODO: Switch `ghc@9.2` to `ghc` once cborg has a new release that supports
  # ghc-prim 0.9.0. PR ref: https://github.com/well-typed/cborg/pull/304
  url "https://hackage.haskell.org/package/dhall-1.41.2/dhall-1.41.2.tar.gz"
  sha256 "6a9a026e698e5c1a1e103fcb376e8494615b03ef2450f0b6c5e6b43877cea592"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bd22495a7d8b81a550fbd182496f2e7fa796e79558a2c1cb668fda63396ac20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0d383f1b6828cb41310c8c7d88484fa95ac7ea051c315d402ee13fdcb4a863f"
    sha256 cellar: :any_skip_relocation, ventura:        "d541205feb74cf43260416c54dfbbe7bc6a4130b027b4a13d801bfbdc92d3e53"
    sha256 cellar: :any_skip_relocation, monterey:       "04fc6b4a5ac1365e1d57bd89c6d00247a7303923a40956a70320c8f15d85b41c"
    sha256 cellar: :any_skip_relocation, big_sur:        "349ecbc7401b06007bc18efb4101199c034bb48c6662652290520fbe13da79f7"
    sha256 cellar: :any_skip_relocation, catalina:       "772a5632c8e01fdbf03e6bccf478f819ce6f0a89fdbfada1afdee95024f3fab7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4898dd03625a01a790749847dcc6cb641543689a755d9b8a043a4d51c01762df"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.2" => :build

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
