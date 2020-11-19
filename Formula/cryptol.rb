class Cryptol < Formula
  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://www.cryptol.net/"
  url "https://hackage.haskell.org/package/cryptol-2.10.0/cryptol-2.10.0.tar.gz"
  sha256 "0bfa21d4766b9ad21ba16ee43b83854f25a84e7ca2b68a14cbe0006b4173ef63"
  license "BSD-3-Clause"
  head "https://github.com/GaloisInc/cryptol.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "92e65fe366183e5231c656e5b2bc3585bf8a6fd2e78c2f628ad9a6fa8c13f3c9" => :big_sur
    sha256 "62143f306e77077070a3d304d596a9803411a12384a421c8f8e652fe0912eadb" => :catalina
    sha256 "8a9d5d3b2317174758ff1b0dc0ec1f82e83036b6afad14608d17527fb03bbb13" => :mojave
    sha256 "2f1d272e3306ea64488a4518ad4366680b07c0e0af05f9939db94ad059c08601" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "z3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
