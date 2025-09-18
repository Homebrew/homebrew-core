class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://github.com/tweag/ormolu/archive/refs/tags/0.8.0.1.tar.gz"
  sha256 "1a1d01fdbe7f1bbe637f8c8b12bee751a2737051bccffbfb1204a76812a64f88"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0acf414ff3ef843cb619d69bbd94c97b58d9c4a551a10d107a3620de4eabd8c9"
    sha256 cellar: :any,                 arm64_sequoia: "8cd936d0ab0a1cc156baaee887fbcc08d3426dc24285a2ff230b0fccf269d96a"
    sha256 cellar: :any,                 arm64_sonoma:  "7d67afdc7ba512a0e6b2bfb806a2a6137c9c5c8b29a15bc2b97fb81df0353559"
    sha256 cellar: :any,                 arm64_ventura: "af904be7e93f1c14f5b79ed5afb8be0a21856fd229b00ba4512e4db67109dfcc"
    sha256 cellar: :any,                 sonoma:        "5b7ce508442d094bc495e55ed88eb0bf337611cd1c1d90d90bfc0881f83de1eb"
    sha256 cellar: :any,                 ventura:       "138ff9d11ad64c64d95f99e4ba9e61e09203b7c954c3695de5dbad3d02b83b39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43252cb31be9499c388aa01999ae5d567a9cc728143d6aac77f5242b43928894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfa834325a547b22fa5ed240c77c5a3c5f6e3dcc4b3990e80d202c0f7628797e"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "-f-fixity-th", *std_cabal_v2_args
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
