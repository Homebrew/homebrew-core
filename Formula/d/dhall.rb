class Dhall < Formula
  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.42.2/dhall-1.42.2.tar.gz"
  sha256 "9a907dd95f4eefee9110f8090d83021371b6b301da315b5b2911c766e0c67b3b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6904e323b779154ef9aa1563882e8e3cac9d22416d1ff28c3a5701248a2ffbf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8a0875538c1eb6776b4a68e35228ac8012593d08df5e9b158b139345f52a8f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f9c27c1448e7ea747a4e43dea0691cfeb1f4b607ce711765a791991ba5213e0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a9eacd1dfa079788283348ba238c3afbc66cae36d4af2eb48019d4b945261a1"
    sha256 cellar: :any_skip_relocation, ventura:       "55434b1c01bf6bf9b264fced924a31aa852523884f2c23826e1a69af74c3b83f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "043f28389aef608dafa4085596e02da1c41a671928bf2a32aab9d05307f2f759"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07be1250410bbcaba21dc5084057529554497b52d942793f4165893a85cabd27"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build

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
