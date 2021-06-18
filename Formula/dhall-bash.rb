class DhallBash < Formula
  desc "Compile Dhall to Bash"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-bash"
  url "https://hackage.haskell.org/package/dhall-bash-1.0.37/dhall-bash-1.0.37.tar.gz"
  sha256 "2df061bcae9341f4627d164c9acd1f2c26b264144e32009a60f94d04abfaa63e"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c508a3b8b8d527b90d61ef3b947acb361de0f450ae1ca1ad1cfb6d969c2ff035"
    sha256 cellar: :any_skip_relocation, big_sur:       "df7fb1a328037fed8fe73c6f8470e624767250a411db158ff21b3b7706a36bab"
    sha256 cellar: :any_skip_relocation, catalina:      "0a9fade0ebbe012abdc5dab4eccd943d26c6449758e8c36e86ce0ee7c7431c0e"
    sha256 cellar: :any_skip_relocation, mojave:        "a98dc2abcc27e896aea7252ce48d0435272058998f6dfcf682f510bf8b3b15e6"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "true", pipe_output("#{bin}/dhall-to-bash", "Natural/even 100", 0)
    assert_match "unset FOO", pipe_output("#{bin}/dhall-to-bash --declare FOO", "None Natural", 0)
  end
end
