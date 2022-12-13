class Fourmolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/fourmolu/fourmolu"
  url "https://github.com/fourmolu/fourmolu/archive/v0.10.1.0.tar.gz"
  sha256 "71adc64cf398cdab3b55310c5d2cdb2e6c5970d63581c28b0c3d8fc49ac45eb7"
  license "BSD-3-Clause"
  head "https://github.com/fourmolu/fourmolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f156016307a109109dd829e4f7f5f241208c6faa8fa51a33ad7efdee26cc16a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "724dc5c416a1961bc8d4444bf56115e1a6da2dde912205c89ebe41984a732a91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0dc70433e6758fe2c22523f0d90bc326ee293e3a1e2624b3d14105bbf11db6e4"
    sha256 cellar: :any_skip_relocation, ventura:        "9eb3b18d545d8e5e67dfa18b4a9a18a8cbf3413483c50c74dd5ad92fc6d0fa64"
    sha256 cellar: :any_skip_relocation, monterey:       "670e7a6628871e02651b683a3ea634ac359891fd1cb887363575391988948865"
    sha256 cellar: :any_skip_relocation, big_sur:        "86226298a955d31d459b345663c8b163c54699c37cf79c58f752e03ac665e8c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49754c69be237ccd781ebb9179c063639d875d78b5b2a437f390d82d86311797"
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
    assert_equal expected, shell_output("#{bin}/fourmolu test.hs")
  end
end
