class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://github.com/tweag/ormolu/archive/0.1.4.0.tar.gz"
  sha256 "be87f996658aea9e93c6ce8ae181b38fbcbcc1eac74b2c00de6abc5d000df25d"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "191f73e59002b4e90f0383df10c9b41ac533468e19147873d0b27a7b4cba4098" => :catalina
    sha256 "f55918963a4eb01ad7be185165a7a72bf73b7638ae1176bb61980eb2d0b6a8c2" => :mojave
    sha256 "0b00fe5d9ceba573d497ed9143c57725ad8d6b2bbc99c3663fb478434659068f" => :high_sierra
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
