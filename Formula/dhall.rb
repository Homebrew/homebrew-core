class Dhall < Formula
  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.38.1/dhall-1.38.1.tar.gz"
  sha256 "f3e95cfa0ef1a89d5ca29591b7925db51551150a27f3fd02717ce69699e8e03c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "ba724dd03858c6e1cbfef358b50a48c2df7c3298b1ad3e3ff6af14ac282475ac"
    sha256 cellar: :any_skip_relocation, catalina: "d91c78ee735fec577fe621c73c56a00e803c0bf130c98ef90f0cd21bdb977b08"
    sha256 cellar: :any_skip_relocation, mojave:   "5b9c420c1f2f1a9f24561c172977912852104d986e8243ec21ade06ad155ebd1"
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
