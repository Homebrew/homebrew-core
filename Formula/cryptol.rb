class Cryptol < Formula
  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://www.cryptol.net/"
  url "https://hackage.haskell.org/package/cryptol-2.9.1/cryptol-2.9.1.tar.gz"
  sha256 "b430d59d9391ddc0506117b08b952412291a142856d8d2cf912f26a4e8258830"
  license "BSD-3-Clause"
  head "https://github.com/GaloisInc/cryptol.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "62143f306e77077070a3d304d596a9803411a12384a421c8f8e652fe0912eadb" => :catalina
    sha256 "8a9d5d3b2317174758ff1b0dc0ec1f82e83036b6afad14608d17527fb03bbb13" => :mojave
    sha256 "2f1d272e3306ea64488a4518ad4366680b07c0e0af05f9939db94ad059c08601" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "z3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  # Fix dependencies https://github.com/GaloisInc/cryptol/issues/879
  # Remove in next version
  patch do
    url "https://github.com/GaloisInc/cryptol/commit/f35fe362.patch?full_index=1"
    sha256 "5abeeb44570d7cdc768b49a5f30dbd8f3133fdb0fd23804911444de70c2b88d0"
  end

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"helloworld.icry").write <<~EOS
      :prove \\(x : [8]) -> x == x
      :prove \\(x : [32]) -> x + zero == x
    EOS
    expected = /Q\.E\.D\..*Q\.E\.D/m
    assert_match expected, shell_output("#{bin}/cryptol -b helloworld.icry")
  end
end
