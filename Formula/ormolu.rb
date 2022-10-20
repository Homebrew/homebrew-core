class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://github.com/tweag/ormolu/archive/0.5.0.1.tar.gz"
  sha256 "589e7e93eb71ba12cdffed9c439025bfa8524d33d66ffd300c195af57720503a"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df90aba393f8c6738350da9930b186f7a94d90d7bf4723f07f9c111ed2d21adf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "496a0fdc72406ebc4336b0b91f088d8ad4e4db327ccec95c294cebdcab1d9b64"
    sha256 cellar: :any_skip_relocation, monterey:       "29ce357cf21e1666e2fc3acb8477cd84b51d2bb2b35a1873a4f94080e7c3340f"
    sha256 cellar: :any_skip_relocation, big_sur:        "528b1e653cb50a23bbc2c28db8b906a1d478f9ef91f49d381b2f649087ad2983"
    sha256 cellar: :any_skip_relocation, catalina:       "4bb90b51e6d9f945acdc4890b668aadbc0f6f777d22c07741a5d88b03c47d3fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc6fd8960d220e78df2cce92b53a8b9c4f487753e6301be1568ed6f6508c39bc"
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
