class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://github.com/tweag/ormolu/archive/refs/tags/0.7.4.0.tar.gz"
  sha256 "7d30dea0adf6511a7a872fadb06cf037bc5ef118450b1618e6d1900785439444"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bca68617d6d7c4e3f10a6dedd0580116768306979ecc6f415962782a3f48ae1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da55704e977be05d1d5e2d3421eef1defb1213c48bf8ca497216db5bcb2833e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6c05ad0de2aedf37f774a062d68d3dda28e4b07902ded028680bddfc416b13c"
    sha256 cellar: :any_skip_relocation, sonoma:         "75c7a19034c4ef35ba985a4ba22f4e5661287a2de3956c2cd3f9c0b70e69e790"
    sha256 cellar: :any_skip_relocation, ventura:        "ab1a7c82e61cc6d0726127fd98f8929526e8b086fff77764686323d2926bd070"
    sha256 cellar: :any_skip_relocation, monterey:       "a0accc8d5c9bb610696e5a34c58a569908c96c30b56b12fc367806c51e83b947"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8661ffe53d6a3d2cd10afed89caa72b3ecd6558b7c03fe67084696146600ee96"
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
