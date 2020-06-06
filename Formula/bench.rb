class Bench < Formula
  desc "Command-line benchmark tool"
  homepage "https://github.com/Gabriel439/bench"
  head "https://github.com/Gabriel439/bench.git"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a1e643d10bcde9bd745eba1b515488c65493cf7d9879cbd7a58bd3661bb6bbdc" => :catalina
    sha256 "ea2a40fb086803f1b7f6a35a9f34aa89509bbbc010a37228fa83ed4ccd1139be" => :mojave
    sha256 "2263dbeca7bcff6a01109ea94a3d27fd4aed15b8c0fe27be5f78f86919c631d4" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build

  stable do
    url "https://hackage.haskell.org/package/bench-1.0.12/bench-1.0.12.tar.gz"
    sha256 "a6376f4741588201ab6e5195efb1e9921bc0a899f77a5d9ac84a5db32f3ec9eb"

    # Compatibility with GHC 8.8. Remove with the next release.
    patch do
      url "https://github.com/Gabriel439/bench/commit/846dea7caeb0aee81870898b80345b9d71484f86.patch?full_index=1"
      sha256 "fac63cd1ddb0af3bda78900df3ac5a4e6b6d2bb8a3d4d94c2f55d3f21dc681d1"
    end
  end

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match /time\s+[0-9.]+/, shell_output("#{bin}/bench pwd")
  end
end
