class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://github.com/tweag/ormolu/archive/0.6.0.1.tar.gz"
  sha256 "ea0bad73e223ecb76fe34f9b843473d58885e442f658a84a75297b4672ae8b7a"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8549e2b820c3d3c08f77029f39fa64cdeef3b29cdaa53df284e40f7d5e4850d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71bab76c95f10d823e062a32f0f1729ff000d93b9f728dd04d2885988b8167e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49290c14da8189a97fd9b163594953b9646eb858abfb19bf2b0d8a2d2a3f240e"
    sha256 cellar: :any_skip_relocation, ventura:        "aca94be44574ee2a3c46c6d475a102d7b9812bb0889fca40cbebb412b4badf6b"
    sha256 cellar: :any_skip_relocation, monterey:       "55228843467edb8bb3d2279f1f6d7d0d825a9d4fe81887a3b506478e43616f6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9068c9e418668ee6c475d62d7f0ee27cdd712a0ad6c5c365df7f907ebba5c989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a505bc22476c81d2bf9fa0b7a3a381ce56704697119bcc11a0616170a88c4ad3"
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
