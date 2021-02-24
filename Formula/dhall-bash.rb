class DhallBash < Formula
  desc "Compile Dhall to Bash"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-bash"
  url "https://hackage.haskell.org/package/dhall-bash-1.0.36/dhall-bash-1.0.36.tar.gz"
  sha256 "806729f2570a2b7b21ea6b22ae3d59068ace7ac680e8b67a5294dd40652fe441"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "ff169b03989ee4be306ae22c8ea13c27c4cbbbfc7788a1a8f7cb235b5c542d41"
    sha256 cellar: :any_skip_relocation, catalina: "9b77b50a8b7e5f4c4120bfce5c8707f6a79ffe7b22dbaae333f9abf8a9615e91"
    sha256 cellar: :any_skip_relocation, mojave:   "fa95bd94241e6deb34609f4d00a837a6b38bb3274add886c0df85b52c00d9e73"
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
