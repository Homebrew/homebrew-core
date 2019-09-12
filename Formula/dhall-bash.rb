require "language/haskell"

class DhallBash < Formula
  include Language::Haskell::Cabal

  desc "Compile Dhall to Bash"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-bash"
  url "https://hackage.haskell.org/package/dhall-bash-1.0.22/dhall-bash-1.0.22.tar.gz"
  sha256 "f2148c390613edc90fad8ddb3598d6e0bd8b1fcd91c135b9fd200d85dc70ace3"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "15014515c7e6150f3f1bc9378b3c243a9dfbefc30f997c45b3d53fd194eb94b8" => :mojave
    sha256 "b7215a16b30d55df079994f26198b9219a88d8caa7258588c2949f898d235ca8" => :high_sierra
    sha256 "0bb33ee9115e73dfd71ce59ad5edeca554d15c41b23f6ab7d23da18e8cd96e6c" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "true", pipe_output("#{bin}/dhall-to-bash", "Natural/even 100", 0)
    assert_match "unset FOO", pipe_output("#{bin}/dhall-to-bash --declare FOO", "None Natural", 0)
  end
end
