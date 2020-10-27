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
    sha256 "255413ce3ff725f3e1c32decec41b4d0435572c9a8c36cd69d96c8e60bd14bda" => :catalina
    sha256 "554c1fbfa317f7c2ac0bc2e907681165c29d6e542227a2918c0530923961af88" => :mojave
    sha256 "3b0a9e5e65404cce129e530b9c1ffb16695988c57d24c4153367b584645b9bf3" => :high_sierra
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
