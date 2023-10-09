class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://github.com/tweag/ormolu/archive/0.7.2.0.tar.gz"
  sha256 "bc0aa2efed178fb67d0b06acffcdefed0ea31f0b9a42af56aec969d49504a124"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b82cecb66cf36ad8f64629cda2bcbb60a07a79778668c5a23e7b09fded34493a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08ba95c61b387c4a63539ee60cb7398e555ee06196c266baddfc091b184cb834"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a91e25eb115a01a12be0636758b268aef69bec0adbb64e8f86164eee076632b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89d40d88f7b2e3ec3220a57ecbd617ef8d35299a437a8e82728dcba4a18ea142"
    sha256 cellar: :any_skip_relocation, sonoma:         "081de4146adf17ffd49f2c251f051484855f7559b05498c0c36e06eaba0a97ef"
    sha256 cellar: :any_skip_relocation, ventura:        "329de960e423b67866b010a0760b560e5392c81435070b88bf1a90a91b6c7050"
    sha256 cellar: :any_skip_relocation, monterey:       "c3fc2fa26c21dc95674f2a0941addc4c6e6aace570db76fac06d184733d6415f"
    sha256 cellar: :any_skip_relocation, big_sur:        "79d0b05ac7b248e23b879629fc6e31aa84d97999189780ba5e383d404a0d9ae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b76c38bb2770cd61a93939f2223ad4f340c4254f6a8f1896a97c6ca76786cb20"
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
