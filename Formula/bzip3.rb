class Bzip3 < Formula
  desc "Better and stronger spiritual successor to BZip2"
  homepage "https://github.com/kspalaiologos/bzip3"
  url "https://github.com/kspalaiologos/bzip3/releases/download/1.2.3/bzip3-1.2.3.tar.gz"
  sha256 "18e23bb09ebb9e8a2f7b09351aad1770277383461e9d36311d575b9cf373653a"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "39f0f0023b86de4076976b638b94efa7f413af13358cd4eb8c9c7c80ebc0e884"
    sha256 cellar: :any,                 arm64_monterey: "5817258169bdf74947d8a4991e4ae31d4283445cbb05b4f59d920a2e5978d752"
    sha256 cellar: :any,                 arm64_big_sur:  "85fb6cc8564409e92fc310e3a1d75ba7d100d358798e5e8fcc77e565a0ca31dc"
    sha256 cellar: :any,                 ventura:        "b4ae896c981e7903e913db2dfe83f59fa487e84e548289a3e84bf12b82c5b4cc"
    sha256 cellar: :any,                 monterey:       "5cda9e905bb5792674ee6104f5ddfe86aa9819c47d24139c826d81109502b96c"
    sha256 cellar: :any,                 big_sur:        "f39157f2f9851f1add2f4b5f77a9135a825224710e79f38ec994c2204bd23c93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "716de15f2d92e118a6daac2997db1ab7cb694f1abc666133ad0104396c3e5757"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--disable-arch-native"
    system "make", "install"
  end

  test do
    testfilepath = testpath + "sample_in.txt"
    zipfilepath = testpath + "sample_in.txt.bz3"

    testfilepath.write "TEST CONTENT"

    system bin/"bzip3", testfilepath
    system bin/"bunzip3", "-f", zipfilepath

    assert_equal "TEST CONTENT", testfilepath.read
  end
end
