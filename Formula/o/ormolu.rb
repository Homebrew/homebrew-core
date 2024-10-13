class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://github.com/tweag/ormolu/archive/refs/tags/0.7.7.0.tar.gz"
  sha256 "443739623df64936894a8197a1c4e275afde65870020f27f61cb51a384bdc437"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "baf141487fd9c3c1a5f14e60a8f3e622e8ada4252a60d44b44eb308a031fd3a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28db55d7c30cc5ee549956cdf5971899b7639931544d054239d9bc37eafcd1ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3c40153dd5605a00b8e133d3ada010feb5d229aeb8dce714727d9e08943a23f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17c3e5a3657bf3d615c56b1dc1ca58412f8f44d7474167522796c006b70dccdc"
    sha256 cellar: :any_skip_relocation, sonoma:         "7dced60b52d4a65ff917164a7cafcd8e468eacdb556a8234c0965d9b857072e9"
    sha256 cellar: :any_skip_relocation, ventura:        "9d51732d3d11b030f02cc15f3bf41428da4f786bc586b6611970b53219b20617"
    sha256 cellar: :any_skip_relocation, monterey:       "0915c0e534f5acc2531b016e254a610476d15ccda7924df8e06d965e6aa928cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e76d2339287a46314ce25d8e8a4b35f863acfa4b4e4d18d5063649b90c2bee9e"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "-f-fixity-th", *std_cabal_v2_args
  end

  test do
    (testpath/"test.hs").write <<~EOS
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
    EOS
    expected = <<~EOS
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
    EOS
    assert_equal expected, shell_output("#{bin}/ormolu test.hs")
  end
end
