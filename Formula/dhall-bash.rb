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
    sha256 "b2096045db1ead5fd9cba3be3ff363503a8ded81bc062dd9d24881c99a2b868a" => :big_sur
    sha256 "1cf2c199a5757bbeddf781dca10c9cd94f307c40f05c1d424778ce00a01b8a9a" => :catalina
    sha256 "43ad85c496ed09fd33c8a2e6b820aa4217ab3a9dd1fe4f0e144c8cea43dacccf" => :mojave
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
