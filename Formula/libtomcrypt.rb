class Libtomcrypt < Formula
  desc "Comprehensive, modular and portable cryptographic toolkit"
  homepage "https://www.libtom.net/"
  url "https://github.com/libtom/libtomcrypt/archive/v1.18.2.tar.gz"
  sha256 "d870fad1e31cb787c85161a8894abb9d7283c2a654a9d3d4c6d45a1eba59952c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2ecaaf5a2d64b92c58498482c3aec69c84c7772ffa5f213ad43010199cd7dec8" => :catalina
    sha256 "fbc00f6bcb941ab719a45ca7a52192b6bda774de1e8997c070fbf025bc031f1a" => :mojave
    sha256 "7dda8583b31d847e69406c4eebda576e6de8fd6a3a5461a73c890bcce3162c05" => :high_sierra
  end

  def install
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "test"
    (pkgshare/"tests").install "tests/test.key"
  end

  test do
    cp_r Dir[pkgshare/"*"], testpath
    system "./test"
  end
end
