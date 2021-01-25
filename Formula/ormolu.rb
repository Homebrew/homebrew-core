class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://github.com/tweag/ormolu/archive/0.1.4.1.tar.gz"
  sha256 "de36baec878120d7d4602737e7313ae82483e2817f9ed1b972da9e016be9fbcb"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a136e8a7b7839d42ee7e915628e5e3c61fc404268f0a83de74dcfac8f2590910" => :big_sur
    sha256 "697dea7abb9261e00041c55500af7401db6a3662b1f37f68e767da86dc06c193" => :catalina
    sha256 "c8cbdf23ff7783d693aa5e70da34d8b81952cddda88c75583c96cb9831733736" => :mojave
    sha256 "2c9bc44aab587a3c8938765dc0b9b1923fe259fa900a9d1e10400a4ad54cdf4e" => :high_sierra
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
