class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://github.com/tweag/ormolu/archive/0.1.4.1.tar.gz"
  sha256 "de36baec878120d7d4602737e7313ae82483e2817f9ed1b972da9e016be9fbcb"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "49f2cb22185aca75c87759e38de2cb72bb530f2d9c0a07c64f88b14454c7efcf"
    sha256 cellar: :any_skip_relocation, big_sur:       "a136e8a7b7839d42ee7e915628e5e3c61fc404268f0a83de74dcfac8f2590910"
    sha256 cellar: :any_skip_relocation, catalina:      "697dea7abb9261e00041c55500af7401db6a3662b1f37f68e767da86dc06c193"
    sha256 cellar: :any_skip_relocation, mojave:        "c8cbdf23ff7783d693aa5e70da34d8b81952cddda88c75583c96cb9831733736"
    sha256 cellar: :any_skip_relocation, high_sierra:   "2c9bc44aab587a3c8938765dc0b9b1923fe259fa900a9d1e10400a4ad54cdf4e"
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
