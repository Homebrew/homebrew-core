class DhallBash < Formula
  desc "Compile Dhall to Bash"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-bash"
  url "https://hackage.haskell.org/package/dhall-bash-1.0.35/dhall-bash-1.0.35.tar.gz"
  sha256 "13e15b1ba3686a596355e5032cf3cdafd13d675c3f7b94d4251ffe5107caeb6c"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "debd6d818fe6d6a00a77a61e59aa40f4f939e51048427c52c3bb4db59ecd81ef" => :big_sur
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
