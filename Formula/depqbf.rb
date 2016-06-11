class Depqbf < Formula
  desc "Solver for quantified boolean formulae (QBF)"
  homepage "https://lonsing.github.io/depqbf/"
  url "https://github.com/lonsing/depqbf/archive/version-4.01.tar.gz"
  sha256 "0246022128890d24b926a9bd17a9d4aa89b179dc05a0fedee33fa282c0ceba5b"
  head "https://github.com/lonsing/depqbf.git"

  bottle do
    cellar :any
    revision 1
    sha256 "400d0d40ad053e45d27c5968f7448664543ed1824d03bb6d0508fa619ad8d7a5" => :el_capitan
    sha256 "8dfd654775860b5d76d7f8d1938ec3b3a497f05deb7995907b0772da9670f85e" => :yosemite
    sha256 "0bf4fa80296fc46ad3ef4956d4b238a18d7ad0390a67f3bb30d84d93faf97c59" => :mavericks
  end

  def install
    system "make"
    bin.install "depqbf"
    lib.install "libqdpll.1.0.dylib"
  end

  test do
    system "#{bin}/depqbf", "-h"
  end
end
