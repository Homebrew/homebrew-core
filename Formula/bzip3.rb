class Bzip3 < Formula
  desc "Better and stronger spiritual successor to BZip2"
  homepage "https://github.com/kspalaiologos/bzip3"
  url "https://github.com/kspalaiologos/bzip3/releases/download/1.2.3/bzip3-1.2.3.tar.gz"
  sha256 "18e23bb09ebb9e8a2f7b09351aad1770277383461e9d36311d575b9cf373653a"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d680e7d31b3081d1d34b3bd7f26bb6a62c5da5d280b244295a76fff67294d5a1"
    sha256 cellar: :any,                 arm64_monterey: "f929812795c45d2e3ea1f0412b0abfc2944bc0788fe1e9ab95a56b37b23fbe61"
    sha256 cellar: :any,                 arm64_big_sur:  "9c2516649a92ef622fcd2eed128fbf32df859df90d8a2c64eb323300cac254a2"
    sha256 cellar: :any,                 ventura:        "45a20b2dc4f0fb730fd5cb6261d2aa442fff39c8495006425167613dd6c6ab7e"
    sha256 cellar: :any,                 monterey:       "fef4f572b3f92408cff6fe5c1d7400464ac40633fc544f447e774aad4801d99f"
    sha256 cellar: :any,                 big_sur:        "85da6d16e655325c5c911aa2e3878c22ff08ebe3000fe7cdbdf0cff96a0573fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be2a3aa600d6a39c8021183883f068789da2157a4837d0235dcc97e9b74d7bd1"
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
