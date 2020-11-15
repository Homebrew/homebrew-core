class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://github.com/tweag/ormolu/archive/0.1.4.1.tar.gz"
  sha256 "de36baec878120d7d4602737e7313ae82483e2817f9ed1b972da9e016be9fbcb"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ee01f8be8e5d977ea3436ce701487af66d1e0b858f072754c48e83544172a38" => :catalina
    sha256 "939649afce92296b1b6b02b6041ab7409856f1cb1bc8c25ed989660ed7aacfa4" => :mojave
    sha256 "0a6ecd608e57debe45a60e8089c8cd2db4aba2ac0efdeb629aaa2960f19b033d" => :high_sierra
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
