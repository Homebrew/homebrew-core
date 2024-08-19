class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://github.com/tweag/ormolu/archive/refs/tags/0.7.6.0.tar.gz"
  sha256 "cecaf48ce9464e956c04b066d7a735b4ca920804b1549b09c2a5acc664e9e434"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b0819862ae5f8334b811fc791765baffd03f42bb68206f2077dcb12b4a793bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aec749199fc7b620af1fc57aa7173d2adfecd06d2f32c1ac758c12cfe65278bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3218d61d656c4ace94dc9864c4c7f50fa927f043774a31f466090bfb5e224ca1"
    sha256 cellar: :any_skip_relocation, sonoma:         "c09777592645c058a4a7cfdfd62df4ad0bed5d5864d4824e7cb4ba30db07dc8e"
    sha256 cellar: :any_skip_relocation, ventura:        "f309e1e8ba8234e9588c21ed3265acadfa2fbdc180256704e6d1e512c27e272d"
    sha256 cellar: :any_skip_relocation, monterey:       "6d691d88cff25e18598d4797332b756765793cad8d46fd06dca9ae2390426dda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5098bbd7e593ad2d57fdfe092716df79878c5c19bed9d5875d4fd16fe5e3abc8"
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
