class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://github.com/tweag/ormolu/archive/0.5.0.1.tar.gz"
  sha256 "589e7e93eb71ba12cdffed9c439025bfa8524d33d66ffd300c195af57720503a"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "828054e2764d487af77e04880eff00bbbfb810d2150eb1ea45c0e6bfb7f14d6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14450fe96a3025dc81dd53dbe85317b9f660f5983cdbe217b6996306f9a378d1"
    sha256 cellar: :any_skip_relocation, monterey:       "d5a10db06a3bc92a52516852f1cc8dc984c1c1a3730e3c6c4d9058c5204b65f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e28da5886bdb97c288f824071f2de68e4f59c3d5e445492468a4985386db531"
    sha256 cellar: :any_skip_relocation, catalina:       "d3c334f656ea463f853e223e858825d8a5443ec4d83b2990b83ead818258600c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6d111b4cbbeba91601a5e4ca3dc28cac17b89a41b8b8270b05e35566af35ca0"
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
