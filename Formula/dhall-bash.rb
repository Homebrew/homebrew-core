class DhallBash < Formula
  desc "Compile Dhall to Bash"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-bash"
  url "https://hackage.haskell.org/package/dhall-bash-1.0.29/dhall-bash-1.0.29.tar.gz"
  sha256 "3ca8c0e6802d7c002d9e1553135fe47431eae91f0acfd065fe3a645ca998b042"
  head "https://github.com/dhall-lang/dhall-haskell.git"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ee0d4ac6a7620e4081aa517db06bdefa58ec610141658a6dfdaf098a5852c7fb" => :catalina
    sha256 "7c3bbb085470847b8169528d4284471de884a301757106083036d47d5c782a03" => :mojave
    sha256 "1eb28dde342827b5e733f1c99f8b19ca516499e6f1eb99218a1b0e7dc19d2f05" => :high_sierra
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
