class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://github.com/tweag/ormolu/archive/0.1.3.0.tar.gz"
  sha256 "c66097ec662063ead62f16b39380ee7cbecda90ed70d84866710d112a269224e"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "14ca12579e0137130bdb48ee2eaaf1610f526bb0e0cd30c1444c1ccbef86a6a2" => :catalina
    sha256 "393da89deaa62a76fe3d0453736f0f94ba8d5ba4ea69b47ea453bcb2351e1f71" => :mojave
    sha256 "09803d60ccbd9bb84b5dd99b8f387c2d4553ffd38aa02545596bc19b38ea4b67" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
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
