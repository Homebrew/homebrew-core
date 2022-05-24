class Libtomcrypt < Formula
  desc "Comprehensive, modular and portable cryptographic toolkit"
  homepage "https://www.libtom.net/"
  url "https://github.com/libtom/libtomcrypt/archive/v1.18.2.tar.gz"
  sha256 "d870fad1e31cb787c85161a8894abb9d7283c2a654a9d3d4c6d45a1eba59952c"
  license "Unlicense"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "159d50a2adf84043773b8377768218e25fc823902d95fc86f0756c4648096a13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95cc1395317bb6d7a70cf54c951c0a1d023fc4dbd9e8d2962dd70493811c2f08"
    sha256 cellar: :any_skip_relocation, monterey:       "b53aaf81eda5f5a40ac308cb25c048e37db76339edf3d30065338588c30f3e12"
    sha256 cellar: :any_skip_relocation, big_sur:        "061be8d1fbb275f323042615a2e6b84057fe35b349b21fe87f8a5a961c975b4a"
    sha256 cellar: :any_skip_relocation, catalina:       "2ecaaf5a2d64b92c58498482c3aec69c84c7772ffa5f213ad43010199cd7dec8"
    sha256 cellar: :any_skip_relocation, mojave:         "fbc00f6bcb941ab719a45ca7a52192b6bda774de1e8997c070fbf025bc031f1a"
    sha256 cellar: :any_skip_relocation, high_sierra:    "7dda8583b31d847e69406c4eebda576e6de8fd6a3a5461a73c890bcce3162c05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8957df3d2611c3979bf19a68c0b0f1cab117c3a434f979b0a6a5cf21f4bc560e"
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
