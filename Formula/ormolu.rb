class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://github.com/tweag/ormolu/archive/0.5.3.0.tar.gz"
  sha256 "3f40ab134489482d4a7ff816089dc6c793649bfa776e2e1105b3c887711d6a73"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c2749672f62b1df95c1413c6d4adc1530163319b156a5eff3bd529d94e57ca5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02558816688d0d7ecc530783bbac25974c21f7546118788a4c2a0004460cc319"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4dd1c35f30b2a340447e3d72684dfef956ec7374d9466675b56a3116f01eecb"
    sha256 cellar: :any_skip_relocation, ventura:        "9f748a359be0264435f8ac3fdf1d916c205874c0489146d5177be23c474518a6"
    sha256 cellar: :any_skip_relocation, monterey:       "abde7ddb02874e7e3f73f6057312895bfc24df108eeed4f26657ae271cb4b340"
    sha256 cellar: :any_skip_relocation, big_sur:        "01e5cce84adc178a23a6e674408b4c41b84cf66129dda1345887fef9dc988db9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "461271a80d64ba7572b225f5de583685a02175f8e1f54f99e2a86c8fc8e1452f"
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
