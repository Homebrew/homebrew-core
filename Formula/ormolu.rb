class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://github.com/tweag/ormolu/archive/0.5.2.0.tar.gz"
  sha256 "ba3a841b5b0340e4a337e311b3a79ff687c0af4389631f0817224bc8db413971"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9afd3402b217a42cc0527f53a9c42e992f7ad247f05fad9da4cb7c374f4d986f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93c07f5e65714f5235a66d264e03ded0389ee5f17d7ce535dd85ff0fa64f6e21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88a0e722d763286d25df1f804b1fe5a364679330ee21af8edf689b2be97d41b8"
    sha256 cellar: :any_skip_relocation, ventura:        "f0d7ed9c5f7d798958b774cf2281adf8bf7699bece19ed6dfca1b8cc6efc9b38"
    sha256 cellar: :any_skip_relocation, monterey:       "b7161af8d79a0f4d106881fc2c00fbc16fd82dd7e8b113042ed96e4d428b592f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0326abd4734ee2aa4078b6858fbaf3985b786ad5f9236e8ec96831a364642c2"
    sha256 cellar: :any_skip_relocation, catalina:       "b1a706b4c77d213e08be73417a751c147f55475151e1d50e878d74bf14557d04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e293ef7522c75afa1663bda7b000c40384c9b4155e71da80a7462988d47af71e"
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
