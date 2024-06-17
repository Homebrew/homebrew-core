class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://github.com/tweag/ormolu/archive/refs/tags/0.7.5.0.tar.gz"
  sha256 "3fefd78d771fb228ad2d698f77644f3d0cfc1dc8cba81c3c560de151aaa052ca"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07cf91e888e54b57c7c1b0e07a69c598709984483efcdfdcbdc00b905bb0e41c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "818f27ba907355202bc225cf893a2fe7b41389cf65377bb389efb8615f7f355f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07cff4d34bccab4f0e930147d636f9635abdc0b42f2df9e0c2b259531cae180e"
    sha256 cellar: :any_skip_relocation, sonoma:         "1beeef2d3367744a3c0a62227b71b063ee2e3dc67f9b3b5519dae310070f717d"
    sha256 cellar: :any_skip_relocation, ventura:        "663bd6ca83ecc0c56a5f9b48aa35e5ba1249f98eb91a2228595341be2dcbc81a"
    sha256 cellar: :any_skip_relocation, monterey:       "ab3c9db1ae4fefb7759208f6d8bc24d633d70e277352c290e4c69d3094b1a6a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1b2b5f9df3a1d2b675bbc124812b1dac42b333665714f899b1826d44ad1e226"
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
