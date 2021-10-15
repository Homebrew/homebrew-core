class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://github.com/tweag/ormolu/archive/0.3.1.0.tar.gz"
  sha256 "b0bbf229f1878c39aa58dbb71d8cc4fbc4713252c7acbc0fd9921804fecbd273"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dadab8b8360008547e73678dbd2c75f962fd00326dac8a154448ba8021426ec3"
    sha256 cellar: :any_skip_relocation, big_sur:       "d8dcd837ab8c6a7ba87ac07df23bd11e2d2ad5858ca3083bc0d599daabd84757"
    sha256 cellar: :any_skip_relocation, catalina:      "9a1617d2a4ec45fd436f6a0a47d6bbe4eb23c36bcb2d7dabfdbd7b23a9c4827d"
    sha256 cellar: :any_skip_relocation, mojave:        "09050087ad3fa52b9e86e9935762071ac930cb33fddc1d2226ee92f0c9a9fd51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8a3eb784f152847d4ea49bef3866f393f449dbe9e8d83b44c78cda7b8f84805"
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
