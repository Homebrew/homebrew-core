class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://hackage.haskell.org/package/ormolu-0.8.1.0/ormolu-0.8.1.0.tar.gz"
  sha256 "120f20bb158b756f8d4dbcac94c2fd0227816e072d3447d83c65c18bdae1f542"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "84548060ac56af705b53354434b59ec5be97349d69795c052ded4ef2aacd31be"
    sha256 cellar: :any,                 arm64_sequoia: "7ca0573df8ed4627e4369b68733e101080f926747e055fe9303fd4f40e14bb3f"
    sha256 cellar: :any,                 arm64_sonoma:  "273e9f6d6622b9017610a5a7809baaf44046f2cb8b931faaa6de952b4fc0a9b1"
    sha256 cellar: :any,                 sonoma:        "fcb5033eb834355988bd87f8e9da2d785889d29e5ae608b05cedca09737144a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83bfb4a1ffb4f303ba9df932daa29af38ecc28bd332712aff1deaf5dc07ecc90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8d4b12ba62e0cd091118111a92eb77972eaa162cdb56c62040221b2d940096e"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.12" => :build # GHC 9.14 PR: https://github.com/tweag/ormolu/pull/1175
  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"test.hs").write <<~HASKELL
      foo =
        f1
        p1
        p2 p3

      foo' =
        f2 p1
        p2
        p3

      foo'' =
        f3 p1 p2
        p3
    HASKELL
    expected = <<~HASKELL
      foo =
        f1
          p1
          p2
          p3

      foo' =
        f2
          p1
          p2
          p3

      foo'' =
        f3
          p1
          p2
          p3
    HASKELL
    assert_equal expected, shell_output("#{bin}/ormolu test.hs")
  end
end
