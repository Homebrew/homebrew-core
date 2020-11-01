class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://github.com/tweag/ormolu/archive/0.1.3.1.tar.gz"
  sha256 "b2451c7492582d5317ac25a4366bea4a06cfaece89c23444bea3e2686ec7ab2a"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5003a13d1a7d595ffc56df509c4bd1d73f16527026b2ea06aa5b5020baba4076" => :catalina
    sha256 "dc17ffd08ccf17fbe7efaea7c37f24633593c7176798a8e3f32cc4f90f72fa13" => :mojave
    sha256 "0d094152eb60388e35dbd4df4d445b9ad3f37170be91c7523bfd925a68fa5ed8" => :high_sierra
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
