class DhallBash < Formula
  desc "Compile Dhall to Bash"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-bash"
  url "https://hackage.haskell.org/package/dhall-bash-1.0.40/dhall-bash-1.0.40.tar.gz"
  sha256 "a9d1feba3c9ceeecdd24fb4a4d8f6450a50ca31ede30aa4d7a8e9d8489cc7f3a"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94344bb3dfd3036109853ecb36f28d04b4acb13caafe370c3255650eb320663c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c5cf8510f9d239e8fee400c48136e4b441ba901fbdc0335c9d1f65b452a3394"
    sha256 cellar: :any_skip_relocation, monterey:       "7f1007390145c0b45b374a2b7eb0d956143fa88b3ffb35807bfef971109f0d33"
    sha256 cellar: :any_skip_relocation, big_sur:        "e93ab3c056dae0d029ff346018e1e49a45343f126fc523af5ada94dd73e8da75"
    sha256 cellar: :any_skip_relocation, catalina:       "c388e918ddc4a2416535cf53173325e483216d92e9dfd24fbfad46acaf6b1ea3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f4ddd5de1e559f1c2e0b5398e9176cb93283b7caae47d9fc6a6e12ca4ee3a02"
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
    assert_match "true", pipe_output("#{bin}/dhall-to-bash", "Natural/even 100", 0)
    assert_match "unset FOO", pipe_output("#{bin}/dhall-to-bash --declare FOO", "None Natural", 0)
  end
end
