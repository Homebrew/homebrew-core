class DhallBash < Formula
  desc "Compile Dhall to Bash"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-bash"
  url "https://hackage.haskell.org/package/dhall-bash-1.0.34/dhall-bash-1.0.34.tar.gz"
  sha256 "3e6652fa7f2b67d49972dc794e8bc1a7a7b93d1f5ff0db338214a02933f53fdc"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "965595403064b60d5a0279689afcbefef97c61a82450fb4fe1c7866426f6160a" => :catalina
    sha256 "25f343265502b17b05f07380aa44de5a8609d175ed9583edcee9df30e8bdfeab" => :mojave
    sha256 "bd07cfc74c40081a414ca3a470fb6f3d7c4359d3c15760adeca82d9674ceaacb" => :high_sierra
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
