require "language/haskell"

class DhallBash < Formula
  include Language::Haskell::Cabal

  desc "Compile Dhall to Bash"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-bash"
  url "https://hackage.haskell.org/package/dhall-bash-1.0.29/dhall-bash-1.0.29.tar.gz"
  sha256 "3ca8c0e6802d7c002d9e1553135fe47431eae91f0acfd065fe3a645ca998b042"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f2c728be89a8156e2348074bc38a8fe751f22f0f7c0d9525946868ab2aaeaf7a" => :catalina
    sha256 "0464d1bae8fdef0a8727f9ca192583b70987711871c1b4a9641e0e60c4db2919" => :mojave
    sha256 "463a973af5913f8ed0561cdf77638e7c879e22559fa11cd2f55b0d3812794a54" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "true", pipe_output("#{bin}/dhall-to-bash", "Natural/even 100", 0)
    assert_match "unset FOO", pipe_output("#{bin}/dhall-to-bash --declare FOO", "None Natural", 0)
  end
end
