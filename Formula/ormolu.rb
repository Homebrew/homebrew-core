class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://github.com/tweag/ormolu/archive/0.2.0.0.tar.gz"
  sha256 "04461449cb6ba79230ffebe9e432765b3a190dacf28b73c4931cbccbe516f8d0"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d8fd89b32a6dbe77698d25b8d5b6a9bde490e1c9e05b73079d9146ea4ab5c032"
    sha256 cellar: :any_skip_relocation, big_sur:       "151d4b1c54440eaf96b72a0b417894d3fe4ca2478eb94a242b3abe144498ea68"
    sha256 cellar: :any_skip_relocation, catalina:      "cdf06624755fe56202d3f0aa504fe0402ada1189e44de0d60a53a8cd7901e83b"
    sha256 cellar: :any_skip_relocation, mojave:        "3e54ed98fd90c029f523657d543bea53ca67d37918144452846dfa059c3d461d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8f12ec8c0d3dec366988d54a859832488996ca0f2d5986c21f4dd01e22ed3d9"
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
