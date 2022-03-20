class Fourmolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/fourmolu/fourmolu"
  url "https://github.com/fourmolu/fourmolu/archive/v0.5.0.tar.gz"
  sha256 "999d380802b1356eeb3e463029282ecf0c56cb1d511783e6d053863890949806"
  license "BSD-3-Clause"
  head "https://github.com/fourmolu/fourmolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed15948ed07b012cb441f21d401521601d91160a03c610b0714d9efce88ece53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe4eb58a841e95f07ebd868f8d8fc52fe9c578ba76354434fceb58f69e8a33ab"
    sha256 cellar: :any_skip_relocation, monterey:       "61279b8535e1e551e90ab7e097f11d20cdc54dcde84649dea4f25a4b35c909e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "9cc7e6236aa91ca1b1bc77612bad1bbf035c3b7508950be3f5b72bef96cda34d"
    sha256 cellar: :any_skip_relocation, catalina:       "377ae1d398ef91090eb0a615a7848c3f67394e69fcf3c50ec3ab0c056c5dda01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7159636520c4964aa1f8b0614d92276716e1ca9d5f01dfd1fb7e2368279b6b31"
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
